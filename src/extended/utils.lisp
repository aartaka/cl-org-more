(in-package :cl-org-more-extended)


(defun execute-with-digesting-stream (digest fn)
  (with-open-stream (stream (ironclad:make-digesting-stream digest))
    (funcall fn stream)
    (ironclad:produce-digest stream)))

(defmacro with-digesting-stream ((var digest) &body body)
  `(execute-with-digesting-stream ,digest (lambda (,var) ,@body)))

(defun execute-with-digesting-text-stream (digest format fn)
  (with-open-stream (stream (ironclad:make-digesting-stream digest))
    (with-open-stream (text-stream (flexi-streams:make-flexi-stream
                                    stream :external-format (flexi-streams:make-external-format format)))
      (funcall fn text-stream)
      (finish-output text-stream)
      (ironclad:produce-digest stream))))

(defmacro with-digesting-text-stream ((var digest &key (external-format :utf-8)) &body body)
  `(execute-with-digesting-text-stream ,digest ,external-format (lambda (,var) ,@body)))
