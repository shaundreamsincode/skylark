function copyToClipboard(text) {
  // Create a temporary textarea element
  const textarea = document.createElement('textarea');
  textarea.value = text;
  textarea.style.position = 'fixed';
  textarea.style.opacity = '0';
  document.body.appendChild(textarea);
  
  // Select and copy the text
  textarea.select();
  document.execCommand('copy');
  
  // Remove the temporary element
  document.body.removeChild(textarea);
  
  // Show feedback (optional)
  alert('Link copied to clipboard!');
} 