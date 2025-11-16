/**
 * PDS Preview PDF Generation
 * Handles direct PDF generation and download functionality
 */

/**
 * Generate and download PDF directly without using window.print()
 * This ensures proper formatting and footer positioning
 */
async function downloadPDF() {
    try {
        // Check if required libraries are loaded
        if (typeof html2canvas === 'undefined') {
            throw new Error('html2canvas library is not loaded. Please refresh the page and try again.');
        }

        // Show loading state
        const downloadBtn = document.querySelector('.btn-download');
        const originalText = downloadBtn ? downloadBtn.innerHTML : '';
        if (downloadBtn) {
            downloadBtn.disabled = true;
            downloadBtn.innerHTML = '⏳ Generating PDF...';
        }

        // Get both pages
        const page1 = document.querySelector('.page-1');
        const page2 = document.querySelector('.page-2');
        
        if (!page1 || !page2) {
            throw new Error('Pages not found. Please refresh the page and try again.');
        }

        console.log('Pages found, extracting student name...');

        // Get student name for filename
        let studentName = 'Student';
        try {
            const formRows = page1.querySelectorAll('.form-row');
            let lastName = '';
            let firstName = '';
            
            formRows.forEach(row => {
                const labels = row.querySelectorAll('label');
                labels.forEach(label => {
                    const labelText = label.textContent.trim();
                    const fieldValue = row.querySelector('.field-value');
                    if (fieldValue) {
                        if (labelText.includes('Last Name')) {
                            lastName = fieldValue.textContent.trim();
                        } else if (labelText.includes('First Name')) {
                            firstName = fieldValue.textContent.trim();
                        }
                    }
                });
            });
            
            if (lastName || firstName) {
                studentName = (lastName + '_' + firstName).trim().replace(/\s+/g, '_').replace(/[^a-zA-Z0-9_]/g, '') || 'Student';
            }
        } catch (e) {
            console.warn('Could not extract student name for filename:', e);
        }

        console.log('Student name:', studentName);

        // Wait for all images to load
        const waitForImages = async (container) => {
            const images = container.querySelectorAll('img');
            const promises = Array.from(images).map(img => {
                if (img.complete && img.naturalHeight !== 0) {
                    return Promise.resolve();
                }
                return new Promise((resolve) => {
                    const timeout = setTimeout(() => {
                        console.warn('Image load timeout:', img.src);
                        resolve();
                    }, 5000);
                    
                    img.onload = () => {
                        clearTimeout(timeout);
                        resolve();
                    };
                    img.onerror = () => {
                        clearTimeout(timeout);
                        console.warn('Image failed to load:', img.src);
                        resolve();
                    };
                });
            });
            await Promise.all(promises);
        };

        console.log('Waiting for images to load...');
        await waitForImages(page1);
        await waitForImages(page2);
        await new Promise(resolve => setTimeout(resolve, 500)); // Extra wait for rendering

        console.log('Images loaded, generating Page 1 canvas...');

        // Generate canvas for page 1 (directly from original element)
        const canvas1 = await html2canvas(page1, {
            scale: 2,
            useCORS: true,
            allowTaint: false,
            logging: false,
            letterRendering: true,
            backgroundColor: '#ffffff',
            ignoreElements: (element) => {
                // Ignore print controls and any iframes
                return element.classList.contains('print-controls') || 
                       element.tagName === 'IFRAME' ||
                       element.tagName === 'SCRIPT';
            },
            onclone: (clonedDoc) => {
                // Clean up cloned document
                const clonedPage1 = clonedDoc.querySelector('.page-1');
                if (clonedPage1) {
                    // Remove print controls from clone
                    const printControls = clonedPage1.querySelector('.print-controls');
                    if (printControls) {
                        printControls.remove();
                    }
                    
                    // Fix footer positioning in clone
                    const footer = clonedPage1.querySelector('.page-footer');
                    if (footer) {
                        footer.style.position = 'absolute';
                        footer.style.bottom = '20px';
                        footer.style.left = '40px';
                        footer.style.right = '40px';
                    }
                }
            }
        });

        console.log('Page 1 canvas generated, generating Page 2 canvas...');

        // Generate canvas for page 2 (directly from original element)
        const canvas2 = await html2canvas(page2, {
            scale: 2,
            useCORS: true,
            allowTaint: false,
            logging: false,
            letterRendering: true,
            backgroundColor: '#ffffff',
            ignoreElements: (element) => {
                // Ignore print controls and any iframes
                return element.classList.contains('print-controls') || 
                       element.tagName === 'IFRAME' ||
                       element.tagName === 'SCRIPT';
            },
            onclone: (clonedDoc) => {
                // Clean up cloned document
                const clonedPage2 = clonedDoc.querySelector('.page-2');
                if (clonedPage2) {
                    // Remove print controls from clone
                    const printControls = clonedPage2.querySelector('.print-controls');
                    if (printControls) {
                        printControls.remove();
                    }
                    
                    // Fix footer positioning in clone
                    const footer = clonedPage2.querySelector('.page-footer');
                    if (footer) {
                        footer.style.position = 'absolute';
                        footer.style.bottom = '20px';
                        footer.style.left = '40px';
                        footer.style.right = '40px';
                    }
                }
            }
        });

        console.log('Page 2 canvas generated, converting to images...');

        // Convert canvases to images
        const imgData1 = canvas1.toDataURL('image/jpeg', 0.98);
        const imgData2 = canvas2.toDataURL('image/jpeg', 0.98);

        console.log('Creating PDF document...');

        // Access jsPDF - try multiple ways to find it
        let jsPDF;
        if (window.jspdf && window.jspdf.jsPDF) {
            jsPDF = window.jspdf.jsPDF;
        } else if (window.jsPDF) {
            jsPDF = window.jsPDF;
        } else {
            throw new Error('jsPDF library is not available. Please refresh the page and try again.');
        }

        // Create new PDF document (8.5 x 11 inches at 96 DPI = 816 x 1056 pixels)
        const pdf = new jsPDF({
            orientation: 'portrait',
            unit: 'px',
            format: [816, 1056],
            compress: true
        });

        console.log('Adding page 1 to PDF...');
        
        // Add page 1
        pdf.addImage(imgData1, 'JPEG', 0, 0, 816, 1056, undefined, 'FAST');

        console.log('Adding page 2 to PDF...');
        
        // Add page 2
        pdf.addPage([816, 1056], 'portrait');
        pdf.addImage(imgData2, 'JPEG', 0, 0, 816, 1056, undefined, 'FAST');

        console.log('Saving PDF...');

        // Save the PDF
        pdf.save(`PDS_${studentName}.pdf`);

        console.log('PDF generated successfully!');
        
        // Restore button state
        if (downloadBtn) {
            downloadBtn.disabled = false;
            downloadBtn.innerHTML = originalText;
        }
        
    } catch (error) {
        console.error('Error generating PDF:', error);
        console.error('Error details:', error.stack);
        
        let errorMessage = 'Error generating PDF: ' + error.message;
        
        // Provide more helpful error messages
        if (error.message.includes('library is not')) {
            errorMessage += '\n\nPlease refresh the page and try again.';
        } else if (error.message.includes('cloned iframe')) {
            errorMessage = 'Error generating PDF: Problem with page elements.\n\nPlease try again or use the Print button instead.';
        }
        
        alert(errorMessage);
        
        // Restore button state
        const downloadBtn = document.querySelector('.btn-download');
        if (downloadBtn) {
            downloadBtn.disabled = false;
            downloadBtn.innerHTML = '📥 Download as PDF';
        }
    }
}
