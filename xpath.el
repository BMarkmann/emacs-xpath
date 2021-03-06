(defun eval-xpath (start end xpath)
  (interactive "r\nMEnter XPath: ")
  (let* ((delimiter "000000000000000000000000")
         (xml (replace-regexp-in-string "[\n\r\s]+" "" (buffer-substring start end)))
         (request (format "%s%s%s" xml delimiter xpath)))
    (with-temp-buffer
      (setq proc (open-network-stream "prog" (current-buffer) "localhost" 5000))
      (process-send-string proc (format "%s%s" request "\n"))
      (accept-process-output proc 1 nil t)
      (let ((result-buffer (create-file-buffer "*XPath Result*"))
            (response (read (buffer-string))))
        (delete-process proc)
        (switch-to-buffer result-buffer)
        (nxml-mode)
        (insert (format "%s%s%s" "<result>" response "</result>"))
        (goto-char -1)
        (while (search-forward-regexp "\>[ \\t]*\<" nil t)
          (backward-char) (insert "\n"))
        (indent-region (point-min) (point-max))))))
        
