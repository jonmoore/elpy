;; Better way of doing tests? Since, I actually need a Django project
;; to test out the `runserver' command
(ert-deftest elpy-module-django-buffer-init ()
  "elpy-django should not be activated since it won't find the
`manage.py' file."
  (elpy-testcase ()
    (elpy-module-django 'buffer-init)

    (should (not elpy-django))))

(ert-deftest elpy-module-django-buffer-stop ()
  (elpy-testcase ()
    (elpy-module-django 'buffer-stop)

    (should (not elpy-django))))

(ert-deftest elpy-module-django-buffer-init-with-manage-file ()
  "When doing a buffer-init, elpy-django should activate when finding
the `manage.py' file."
  (elpy-testcase ()
    (with-temp-file (concat default-directory "manage.py"))
    (elpy-module-django 'buffer-init)

    (should elpy-django)
    (should (string= elpy-django-command (concat default-directory "manage.py")))

    (delete-file (concat default-directory "manage.py"))))

(ert-deftest elpy-module-django-manual-init ()
  "When turning elpy-django manually, `elpy-django-command' should
default to `django-admin.py'."
  (elpy-testcase ()
    (elpy-django 1)

    (should elpy-django)
    (should (string= "django-admin.py" elpy-django-command))))

(ert-deftest elpy-module-django-command ()
  (mletf* ((compile (arg) arg)
           (output (elpy-django-command "migrate")))
          (should (string= output "django-admin.py migrate"))))

;; Test the parsing. Also, another way of shortening string?
;; Already made it shorter but still seems to long
(ert-deftest elpy-module-django-get-commands ()
  (mletf* ((shell-command-to-string (arg) "Type 'manage.py help <subcommand>' for help on a specific subcommand.

Available subcommands:

[auth]
    changepassword

[django]
    migrate

[sessions]
    clearsessions

[staticfiles]
    runserver
"))
    (should (member "runserver" (elpy-django--get-commands)))
    (should (member "clearsessions" (elpy-django--get-commands)))
    (should (member "migrate" (elpy-django--get-commands)))
    (should (member "changepassword" (elpy-django--get-commands)))))
