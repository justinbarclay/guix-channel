(define-module (justins-channel)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages)
  #:use-module (guix build-system font)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix utils))

;; Fonts
(define-public font-nerd-fonts
  (package
   (name "font-nerd-fonts")
   (version "v2.2.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/ryanoasis/nerd-fonts")
           (commit version)))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "064khkp7q11hv8gfygddw54079hfmz0mypghjyfr1x3hmannmp1i"))))
   (build-system font-build-system)
   (arguments
    `(#:phases
      (modify-phases %standard-phases
                     (add-before 'install 'make-files-writable
                                 (lambda _
                                   (for-each
                                    make-file-writable
                                    (find-files "." ".*\\.(otf|otc|ttf|ttc)$"))
                                   #t)))))
   (home-page "https://www.nerdfonts.com/")
   (synopsis "Iconic font aggregator, collection, and patcher")
   (description
    "Nerd Fonts patches developer targeted fonts with a high number
of glyphs (icons).  Specifically to add a high number of extra glyphs
from popular ‘iconic fonts’ such as Font Awesome, Devicons, Octicons,
and others.")
   (license expat)))

(define-public font-nerd-fonts-fira-code
  (package
   (name "font-nerd-fonts-fira-code")
   (version "2.2.1")
   (source
    (origin
     (method url-fetch)
     (uri
      (string-append
       "https://github.com/ryanoasis/nerd-fonts/releases/download/v"
       version
       "/FiraCode.zip"))
     (sha256
      (base32
       "064khkp7q11hv8gfygddw54079hfmz0mypghjyfr1x3hmannmp1i"))))
   (build-system font-build-system)
   (arguments
    `(#:phases
      (modify-phases %standard-phases
        (add-before 'install 'make-files-writable
          (lambda _
            (for-each
             make-file-writable
             (find-files "." ".*\\.(otf|otc|ttf|ttc)$"))
            #t)))))
   (home-page "https://www.nerdfonts.com/")
   (synopsis "Nerd fonts variant of FiraCode font")
   (description
    "Nerd fonts variant of FiraCode font.  Nerd Fonts is a project that patches
developer targeted fonts with a high number of glyphs (icons).  Specifically to
add a high number of extra glyphs from popular 'iconic fonts' such as Font
Awesome, Devicons, Octicons, and others.")
   (license expat)))

(define-public font-nerd-fonts-cascadia-code
  (package
   (name "font-nerd-fonts-cascadia-code")
   (version "2.2.1")
   (source
    (origin
     (method url-fetch)
     (uri
      (string-append
       "https://github.com/ryanoasis/nerd-fonts/releases/download/v"
       version
       "/CascadiaCode.zip"))
     (sha256
      (base32
       "0r8c93f6ysqwl6bsb3avjnhx20fcxz6ng0mwddhcaz14dhl9y0q6"))))
   (build-system font-build-system)
   (arguments
    `(#:phases
      (modify-phases %standard-phases
        (add-before 'install 'make-files-writable
          (lambda _
            (for-each
             make-file-writable
             (find-files "." ".*\\.(otf|otc|ttf|ttc)$"))
            #t)))))
   (home-page "https://www.nerdfonts.com/")
   (synopsis "Nerd fonts variant of FiraCode font")
   (description
    "Nerd fonts variant of FiraCode font.  Nerd Fonts is a project that patches
developer targeted fonts with a high number of glyphs (icons).  Specifically to
add a high number of extra glyphs from popular 'iconic fonts' such as Font
Awesome, Devicons, Octicons, and others.")
   (license expat)))

;; Libraries
(define-public imagemagick-7
  (package
   (inherit imagemagick)
   (version "7.1.0-54")
   (source (origin
              (method url-fetch)
              (uri (string-append "mirror://imagemagick/ImageMagick-"
                                  version ".tar.xz"))
              (sha256
               (base32
                "1xrfs83vr3gdnrag7k7jvb88cqvp173a8hm3frr6fyr100h9a3bd"))))))

;; Programs
(define-public emacs-master
  (let ((commit "073da412a139e317959f56e359ed12de726a0a35")
        (revision "1"))
    (package
     (inherit emacs)
     (name "emacs-master")
     (version (git-version "30.0.50" revision commit))
     (source
      (origin
       (inherit (package-source emacs))
       (method git-fetch)
       (uri (git-reference
             (url "https://git.savannah.gnu.org/git/emacs.git/")
             (commit commit)))
       (file-name (git-file-name name version))
       ;; emacs-source-date-epoch.patch is no longer necessary
       (patches (search-patches "emacs-exec-path.patch"
                                "emacs-fix-scheme-indent-function.patch"
                                "emacs-native-comp-driver-options.patch"))
       (sha256
        (base32
         "0y53bbwj3fqfki53k2178cs4myvb4w466svkz6sgl4v296xvmys2"))))
     (inputs
      (modify-inputs (package-inputs emacs)
                     (prepend sqlite)))
     (native-inputs
      (modify-inputs (package-native-inputs emacs)
                     (prepend autoconf))))))

;; Shell
;; (define-public zinit
;;   (package
;;     (name "zinit")
;;     (version "3.9.0")
;;     (source (origin
;;               (method git-fetch)
;;               (uri (git-reference
;;                     (url "https://github.com/zdharma-continuum/zinit")
;;                     (commit (string-append "v" version))))
;;               (file-name (git-file-name name version))
;;               (sha256
;;                (base32
;;                 ""))))
;;     (build-system gnu-build-system)
;;     (home-page "https://github.com/zdharma-continuum/zinit")
;;     (synopsis "Flexible and fast ZSH plugin manager")
;;     (description
;;      "Zinit is a flexible and fast Zshell plugin manager that will allow you
;; to install everything from GitHub and other sites.")
;;     (license license:expat)))
