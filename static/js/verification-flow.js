(function (window, document, $) {
  document.addEventListener('DOMContentLoaded', function () {
    if (!window.bootstrap) {
      console.warn('Bootstrap is required for verification modals.');
      return;
    }

    const emailModalEl = document.getElementById('emailVerificationModal');
    if (!emailModalEl) {
      return;
    }

    const emailModal = new bootstrap.Modal(emailModalEl, { backdrop: 'static', keyboard: false });

    const emailTargetEls = emailModalEl.querySelectorAll('.verification-target-email');
    const emailForm = document.getElementById('emailCodeForm');
    const emailInput = document.getElementById('emailCodeInput');
    const emailStatus = document.getElementById('emailCodeStatus');
    const resendEmailBtn = document.getElementById('resendEmailCodeBtn');
    const emailSubmitBtn = document.getElementById('emailCodeSubmitBtn');

    const state = {
      email: ''
    };

    function setState(email) {
      if (email) state.email = email;
      emailTargetEls.forEach((el) => (el.textContent = state.email || 'your email'));
    }

    function resetForms() {
      if (emailForm) emailForm.reset();
      clearStatus(emailStatus);
    }

    function clearStatus(el) {
      if (!el) return;
      el.classList.add('d-none');
      el.classList.remove('alert-danger', 'alert-success', 'alert-info');
      el.textContent = '';
    }

    function setStatus(el, message, type) {
      if (!el) return;
      el.classList.remove('d-none', 'alert-danger', 'alert-success', 'alert-info');
      el.classList.add(`alert-${type}`);
      el.textContent = message;
    }

    function toggleButton(btn, disabled) {
      if (!btn) return;
      btn.disabled = disabled;
    }

    function submitForm(path, payload) {
      const formData = new FormData();
      Object.entries(payload || {}).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          formData.append(key, value);
        }
      });
      return $.SystemScript.executePost(path, formData);
    }

    function showEmailModal(email) {
      setState(email);
      resetForms();
      if (emailModal) emailModal.show();
    }

    function handleRedirectAfterSuccess() {
      setStatus(emailStatus, 'Email verified! Redirecting to login...', 'success');
      setTimeout(() => {
        window.location.href = '/login';
      }, 1500);
    }

    if (emailForm) {
      emailForm.addEventListener('submit', function (e) {
        e.preventDefault();
        if (!state.email) {
          setStatus(emailStatus, 'Missing email address. Please start the verification again.', 'danger');
          return;
        }
        const code = (emailInput.value || '').trim();
        if (code.length !== 6) {
          setStatus(emailStatus, 'Please enter the 6-digit code.', 'danger');
          return;
        }
        toggleButton(emailSubmitBtn, true);
        clearStatus(emailStatus);
        submitForm('/verify-email-code', { email: state.email, code })
          .done((response) => {
            const res = response.data || {};
            if (res.status === 'success') {
              setStatus(emailStatus, res.message || 'Email verified!', 'success');
              setTimeout(() => {
                emailModal.hide();
                handleRedirectAfterSuccess();
              }, 600);
            } else {
              setStatus(emailStatus, res.message || 'Unable to verify email code.', 'danger');
            }
          })
          .fail(() => {
            setStatus(emailStatus, 'Something went wrong. Please try again.', 'danger');
          })
          .always(() => toggleButton(emailSubmitBtn, false));
      });
    }

    if (resendEmailBtn) {
      resendEmailBtn.addEventListener('click', function () {
        if (!state.email) {
          setStatus(emailStatus, 'Missing email address. Please restart verification.', 'danger');
          return;
        }
        toggleButton(resendEmailBtn, true);
        clearStatus(emailStatus);
        submitForm('/resend-email-code', { email: state.email })
          .done((response) => {
            const res = response.data || {};
            const type = res.status === 'success' ? 'success' : 'danger';
            setStatus(emailStatus, res.message || 'Unable to resend code.', type);
          })
          .fail(() => {
            setStatus(emailStatus, 'Something went wrong. Please try again.', 'danger');
          })
          .always(() => toggleButton(resendEmailBtn, false));
      });
    }

    window.VerificationFlow = {
      start(email) {
        if (!emailModal) return;
        showEmailModal(email);
      },
      requireEmail(email) {
        if (!emailModal) return;
        showEmailModal(email);
      }
    };
  });
})(window, document, window.jQuery || $ || {});
