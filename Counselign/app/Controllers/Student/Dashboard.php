<?php

namespace App\Controllers\Student;


use App\Helpers\SecureLogHelper;
use App\Helpers\TimezoneHelper; // Add this import
use App\Controllers\BaseController;
use CodeIgniter\API\ResponseTrait;
use App\Models\QuoteModel;
use App\Models\ResourceModel;


class Dashboard extends BaseController
{
    use ResponseTrait;
    public function index()
    {
        // Check if user is logged in and is a regular user
        if (!session()->get('logged_in') || session()->get('role') !== 'student') {
            return redirect()->to('/');
        }

        $data = [
            'title' => 'Student Dashboard',
            'username' => session()->get('username'),
            'email' => session()->get('email')
        ];

        return view('student/dashboard', $data);
    }

    public function getProfileData()
    {
        // Check if user is logged in and is a student
        if (!session()->get('logged_in') || session()->get('role') !== 'student') {
            return $this->response->setJSON(['success' => false, 'message' => 'Access denied']);
        }

        try {
            // Get database connection
            $db = \Config\Database::connect();
            
            // Query to fetch user data
            $builder = $db->table('users');
            $builder->select('user_id, username, email, profile_picture, last_login');
            $builder->where('id', session()->get('user_id'));
            $query = $builder->get();
            
            if ($user = $query->getRowArray()) {
                // Always return a full URL for the profile picture
                if (!empty($user['profile_picture'])) {
                    if (strpos($user['profile_picture'], 'http') === 0) {
                        // Already a full URL
                        $user['profile_picture'] = $user['profile_picture'];
                    } else {
                        // Make sure it starts with a single slash
                        $relativePath = '/' . ltrim($user['profile_picture'], '/');
                        // Build the full URL using baseURL
                        $user['profile_picture'] = base_url($relativePath);
                    }
                } else {
                    // Fallback to default profile picture
                    $user['profile_picture'] = base_url('Photos/profile.png');
                }
                
                log_message('debug', 'Student data fetched successfully: ' . json_encode($user));
                return $this->response->setJSON(['success' => true, 'data' => $user]);
            } else {
                log_message('error', 'No user found with ID: ' . session()->get('user_id'));
                return $this->response->setJSON(['success' => false, 'message' => 'User data not found']);
            }
            
        } catch (\Exception $e) {
            log_message('error', 'Database error: ' . $e->getMessage());
            return $this->response->setJSON(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
        }
    }

    public function getApprovedQuotes()
    {
        try {
            $quoteModel = new QuoteModel();

            // Get all approved quotes, ordered randomly but prefer less-displayed ones
            $quotes = $quoteModel
                ->where('status', 'approved')
                ->orderBy('times_displayed', 'ASC')
                ->orderBy('RAND()')
                ->limit(10) // Limit to 10 most relevant quotes
                ->findAll();

            return $this->respond([
                'success' => true,
                'quotes' => $quotes,
                'count' => count($quotes)
            ]);
        } catch (\Exception $e) {
            log_message('error', '[Quote Carousel] Error fetching approved quotes: ' . $e->getMessage());

            return $this->respond([
                'success' => false,
                'message' => 'Failed to load quotes',
                'quotes' => []
            ], 500);
        }
    }

    /**
     * Get resources visible to students
     */
    public function getResources()
    {
        if (!session()->get('logged_in') || session()->get('role') !== 'student') {
            return $this->respond(['success' => false, 'message' => 'Unauthorized'], 401);
        }

        try {
            $resourceModel = new ResourceModel();
            $resources = $resourceModel->getResourcesByVisibility('students', true);
            
            // Format file sizes and dates
            foreach ($resources as &$resource) {
                if ($resource['file_size']) {
                    $resource['file_size_formatted'] = $this->formatFileSize($resource['file_size']);
                }
                $resource['created_at_formatted'] = date('M d, Y h:i A', strtotime($resource['created_at']));
            }
            
            return $this->respond(['success' => true, 'resources' => $resources]);
        } catch (\Exception $e) {
            log_message('error', '[Student Resources] Error fetching resources: ' . $e->getMessage());
            return $this->respond(['success' => false, 'message' => 'Failed to load resources'], 500);
        }
    }

    /**
     * Format file size
     */
    private function formatFileSize($bytes)
    {
        if ($bytes >= 1073741824) {
            return number_format($bytes / 1073741824, 2) . ' GB';
        } elseif ($bytes >= 1048576) {
            return number_format($bytes / 1048576, 2) . ' MB';
        } elseif ($bytes >= 1024) {
            return number_format($bytes / 1024, 2) . ' KB';
        } else {
            return $bytes . ' bytes';
        }
    }
} 