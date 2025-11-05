import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/counselor_messages_viewmodel.dart';
import 'models/counselor_message.dart';
import 'widgets/counselor_screen_wrapper.dart';
import '../routes.dart';
import '../utils/online_status.dart';

class CounselorMessagesScreen extends StatefulWidget {
  const CounselorMessagesScreen({super.key});

  @override
  State<CounselorMessagesScreen> createState() =>
      _CounselorMessagesScreenState();
}

class _CounselorMessagesScreenState extends State<CounselorMessagesScreen> {
  late CounselorMessagesViewModel _viewModel;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _messagesScrollController = ScrollController();
  String? _selectedMessageId;

  @override
  void initState() {
    super.initState();
    _viewModel = CounselorMessagesViewModel();
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _messageController.dispose();
    _searchController.dispose();
    _messagesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Builder(
        builder: (context) {
          return CounselorScreenWrapper(
            currentBottomNavIndex: -1, // Not part of bottom navigation
            child: _buildMainContent(context),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Consumer<CounselorMessagesViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          height:
              MediaQuery.of(context).size.height - 80, // Reduced header space
          child: Row(
            children: [
              // Conversations Sidebar
              SizedBox(
                width: isMobile ? MediaQuery.of(context).size.width : 350,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      right: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: _buildConversationsSidebar(
                    context,
                    viewModel,
                    isMobile,
                  ),
                ),
              ),

              // Chat Area
              if (!isMobile)
                Expanded(child: _buildChatArea(context, viewModel, isMobile)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConversationsSidebar(
    BuildContext context,
    CounselorMessagesViewModel viewModel,
    bool isMobile,
  ) {
    return Column(
      children: [
        // Sidebar Header
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: const Color(0xFF191970),
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Conversations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (isMobile)
                IconButton(
                  onPressed: () {
                    // Close sidebar on mobile
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
            ],
          ),
        ),

        // Search Box
        Container(
          padding: const EdgeInsets.all(16),
          child: Material(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF191970)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onChanged: (value) {
                viewModel.searchConversations(value);
              },
              autocorrect: false,
              enableSuggestions: false,
              // Disable browser/engine spellcheck
              spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
            ),
          ),
        ),

        // Conversations List
        Expanded(child: _buildConversationsList(context, viewModel)),
      ],
    );
  }

  Widget _buildConversationsList(
    BuildContext context,
    CounselorMessagesViewModel viewModel,
  ) {
    if (viewModel.isLoadingConversations) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF191970)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading conversations...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (viewModel.conversationsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error loading conversations',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.conversationsError!,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadConversations(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF191970),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final conversations = viewModel.filteredConversations;

    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              viewModel.isSearching
                  ? 'No conversations found'
                  : 'No conversations yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (viewModel.isSearching) ...[
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search terms',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        final isSelected = conversation.userId == viewModel.selectedUserId;

        return Container(
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF191970).withValues(alpha: 0.1)
                : null,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 23,
              backgroundColor: const Color(0xFF191970).withValues(alpha: 0.1),
              backgroundImage: conversation.profilePicture != null
                  ? NetworkImage(conversation.profilePicture!)
                  : null,
              child: conversation.profilePicture == null
                  ? const Icon(Icons.person, color: Color(0xFF191970), size: 24)
                  : null,
            ),
            title: Text(
              conversation.userName,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF191970) : Colors.black87,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.truncatedLastMessage,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      conversation.onlineStatus.statusIcon,
                      size: 8,
                      color: conversation.onlineStatus.statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      conversation.onlineStatus.text,
                      style: TextStyle(
                        color: conversation.onlineStatus.statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation.lastMessageTime,
                  style: TextStyle(color: Colors.grey[500], fontSize: 10),
                ),
                if (conversation.hasUnreadMessages) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      conversation.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            onTap: () {
              viewModel.selectConversation(conversation.userId);
              // On mobile, navigate to chat area with provider context
              if (MediaQuery.of(context).size.width < 600) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ChangeNotifierProvider.value(
                      value: viewModel,
                      child: Consumer<CounselorMessagesViewModel>(
                        builder: (ctx2, vm, _) {
                          return Scaffold(
                            backgroundColor: Colors.white,
                            body: _buildChatArea(ctx2, vm, true),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildChatArea(
    BuildContext context,
    CounselorMessagesViewModel viewModel,
    bool isMobile,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: isMobile
            ? null
            : Border(left: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        children: [
          // Chat Header
          _buildChatHeader(context, viewModel, isMobile),

          // Messages Area
          Expanded(child: _buildMessagesArea(context, viewModel)),

          // Message Input
          _buildMessageInput(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildChatHeader(
    BuildContext context,
    CounselorMessagesViewModel viewModel,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 48, 16, 2),
      decoration: BoxDecoration(
        color: const Color(0xFF191970),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            backgroundImage: viewModel.selectedUserAvatar != null
                ? NetworkImage(viewModel.selectedUserAvatar!)
                : null,
            child: viewModel.selectedUserAvatar == null
                ? const Icon(Icons.person, color: Colors.white, size: 20)
                : null,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.selectedUserName ?? 'Messages',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  viewModel.selectedUserId != null
                      ? _getSelectedUserStatus(viewModel)
                      : 'Select a conversation to start messaging',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea(
    BuildContext context,
    CounselorMessagesViewModel viewModel,
  ) {
    if (viewModel.selectedUserId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Messages Yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a conversation from the list to view messages.',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (viewModel.isLoadingMessages) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF191970)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading messages...',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Reset and reload messages
                viewModel.resetMessages();
                viewModel.loadMessages(viewModel.selectedUserId!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF191970),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry Loading'),
            ),
          ],
        ),
      );
    }

    if (viewModel.messagesError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error loading messages',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.messagesError!,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  viewModel.loadMessages(viewModel.selectedUserId!),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF191970),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (viewModel.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Messages Yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start the conversation by sending a message.',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // REMOVED: The ValueKey that was preventing rebuilds
    return ListView.builder(
      controller: _messagesScrollController,
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.messages.length,
      itemBuilder: (context, index) {
        final message = viewModel.messages[index];
        return _buildMessageBubble(context, message, viewModel);
      },
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    CounselorMessage message,
    CounselorMessagesViewModel viewModel,
  ) {
    final isSent = message.isSent;
    final isTimeVisible = _selectedMessageId == message.messageId.toString();

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment: isSent
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isSent
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isSent) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(
                    0xFF191970,
                  ).withValues(alpha: 0.1),
                  backgroundImage: viewModel.selectedUserAvatar != null
                      ? NetworkImage(viewModel.selectedUserAvatar!)
                      : null,
                  child: viewModel.selectedUserAvatar == null
                      ? const Icon(
                          Icons.person,
                          color: Color(0xFF191970),
                          size: 16,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    // CHANGED: Wrap setState in a microtask to ensure immediate rebuild
                    Future.microtask(() {
                      if (mounted) {
                        setState(() {
                          _selectedMessageId = isTimeVisible
                              ? null
                              : message.messageId.toString();
                        });
                      }
                    });
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSent
                          ? const Color(0xFF191970)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20).copyWith(
                        bottomLeft: isSent
                            ? const Radius.circular(20)
                            : const Radius.circular(4),
                        bottomRight: isSent
                            ? const Radius.circular(4)
                            : const Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      message.messageText,
                      style: TextStyle(
                        color: isSent ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              if (isSent) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(
                    0xFF191970,
                  ).withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF191970),
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
          if (isTimeVisible)
            Padding(
              padding: EdgeInsets.only(
                top: 4,
                left: isSent ? 0 : 40,
                right: isSent ? 40 : 0,
              ),
              child: Text(
                message.formattedTime,
                style: TextStyle(color: Colors.grey[600], fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(
    BuildContext context,
    CounselorMessagesViewModel viewModel,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              child: TextField(
                controller: _messageController,
                enabled: viewModel.selectedUserId != null,
                decoration: InputDecoration(
                  hintText: viewModel.selectedUserId != null
                      ? 'Type your message...'
                      : 'Select a conversation to reply...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Color(0xFF191970)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                autocorrect: false,
                enableSuggestions: false,
                spellCheckConfiguration:
                    const SpellCheckConfiguration.disabled(),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty &&
                      viewModel.selectedUserId != null) {
                    _sendMessage();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: viewModel.selectedUserId != null
                  ? const Color(0xFF191970)
                  : Colors.grey[400],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: viewModel.selectedUserId != null ? _sendMessage : null,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _viewModel.selectedUserId == null) return;

    _messageController.clear();

    final success = await _viewModel.sendMessage(messageText);
    if (success && mounted) {
      // Scroll to bottom after sending
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_messagesScrollController.hasClients) {
          _messagesScrollController.animateTo(
            _messagesScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send message. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Get the online status text for the selected user
  String _getSelectedUserStatus(CounselorMessagesViewModel viewModel) {
    final statusResult = OnlineStatus.calculateOnlineStatus(
      viewModel.selectedUserLastActivity,
      viewModel.selectedUserLastLogin,
      viewModel.selectedUserLogoutTime,
    );
    return statusResult.text;
  }
}
