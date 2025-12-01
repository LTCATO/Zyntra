(function () {
  if (typeof axios === 'undefined') {
    console.warn('Axios is required for wishlist interactions.');
    return;
  }

  const TOGGLE_ENDPOINT = '/api/wishlist/toggle';
  const MOVE_TO_CART_ENDPOINT = '/api/wishlist/add-to-cart';

  function init() {
    document.addEventListener('click', handleActionClick, true);
    registerNamespace();
  }

  function handleActionClick(event) {
    const button = event.target.closest('[data-action]');
    if (!button) return;

    const action = button.dataset.action;
    if (action === 'wishlist') {
      event.preventDefault();
      toggleWishlist(button);
    } else if (action === 'wishlist-add-to-cart') {
      event.preventDefault();
      addWishlistItemToCart(button);
    }
  }

  function toggleWishlist(button) {
    const productId = parseInt(button.dataset.productId, 10);
    if (!productId || button.disabled) return;

    setLoading(button, true);
    postJSON(TOGGLE_ENDPOINT, { product_id: productId })
      .then((response) => {
        handleWishlistToggleResponse(button, response);
      })
      .finally(() => setLoading(button, false));
  }

  function addWishlistItemToCart(button) {
    const productId = parseInt(button.dataset.productId, 10);
    if (!productId || button.disabled) return;

    setLoading(button, true);
    postJSON(MOVE_TO_CART_ENDPOINT, { product_id: productId })
      .then((response) => {
        handleWishlistMoveToCartResponse(button, response);
      })
      .finally(() => setLoading(button, false));
  }

  function handleWishlistToggleResponse(button, response) {
    if (!response) return;

    if (response.status === 'success' && response.data) {
      const isActive = !!response.data.is_wishlist;
      setButtonState(button, isActive);
      updateBadges(response.data);

      if (!isActive) {
        removeWishlistCard(button);
      }

      showToast(
        'success',
        isActive ? 'Added to wishlist.' : 'Removed from wishlist.'
      );
    } else {
      showToast('error', response.message || 'Unable to update wishlist.');
    }
  }

  function handleWishlistMoveToCartResponse(button, response) {
    if (!response) return;

    if (response.status === 'success' && response.data) {
      updateBadges(response.data);
      removeWishlistCard(button);
      showToast('success', 'Item moved to your cart.');
    } else {
      showToast('error', response.message || 'Unable to move item to cart.');
    }
  }

  function removeWishlistCard(button) {
    const wishlistCard = button.closest('.wishlist-card');
    if (wishlistCard) {
      const column = wishlistCard.closest('[class*="col"]') || wishlistCard;
      column.remove();
      checkWishlistEmptyState();
      return;
    }

    // Non-wishlist pages only need visual state toggle.
  }

  function checkWishlistEmptyState() {
    const grid = document.getElementById('wishlist-grid');
    if (!grid) return;

    const remainingCards = grid.querySelectorAll('.wishlist-card');
    let emptyState = document.querySelector('[data-wishlist-empty]');

    if (remainingCards.length === 0) {
      if (!emptyState) {
        emptyState = document.createElement('div');
        emptyState.className = 'wishlist-empty-state text-center';
        emptyState.dataset.wishlistEmpty = 'true';
        emptyState.innerHTML = `
          <i class="bi bi-heart fs-1 text-muted mb-3"></i>
          <h3 class="fw-bold mb-2">Your wishlist is empty</h3>
          <p class="text-muted mb-4">Start exploring our catalog and tap the heart icon to save products for later.</p>
          <a href="/" class="btn btn-primary px-4">
            <i class="bi bi-arrow-left me-2"></i>Back to Shopping
          </a>
        `;
        grid.insertAdjacentElement('afterend', emptyState);
      }
      emptyState.classList.remove('d-none');
    } else if (emptyState) {
      emptyState.classList.add('d-none');
    }
  }

  function updateBadges(data) {
    if (!data) return;

    const wishlistBadge = document.querySelector('[data-wishlist-count]');
    if (wishlistBadge) {
      const count = parseInt(data.wishlist_count, 10) || 0;
      wishlistBadge.textContent = count > 0 ? count : '';
      wishlistBadge.classList.toggle('d-none', count === 0);
    }

    const cartBadge = document.querySelector('.zyn-cart-btn[title="Cart"] .zyn-cart-badge');
    if (cartBadge) {
      const count = parseInt(data.cart_count, 10) || 0;
      cartBadge.textContent = count > 0 ? count : '';
      cartBadge.classList.toggle('d-none', count === 0);
    }
  }

  function registerNamespace() {
    window.ZynWishlist = window.ZynWishlist || {};
    window.ZynWishlist.refresh = function () {
      // Event delegation handles dynamic content automatically.
    };
    window.ZynWishlist.updateBadges = updateBadges;
  }

  function setButtonState(button, isActive) {
    button.classList.toggle('is-active', isActive);
    const icon = button.querySelector('i');
    if (icon) {
      icon.classList.remove('bi-heart', 'bi-heart-fill');
      icon.classList.add(isActive ? 'bi-heart-fill' : 'bi-heart');
    }
  }

  function setLoading(button, isLoading) {
    if (!button) return;
    button.disabled = !!isLoading;
    button.classList.toggle('is-loading', !!isLoading);
  }

  function postJSON(url, payload) {
    return axios
      .post(url, payload)
      .then((response) => response.data)
      .catch((error) => {
        if (error.response && error.response.data) {
          return error.response.data;
        }
        return { status: 'error', message: 'Something went wrong.' };
      });
  }

  function showToast(type, message) {
    if (typeof Swal !== 'undefined' && typeof Swal.fire === 'function') {
      Swal.fire({
        toast: true,
        position: 'top-end',
        icon: type === 'error' ? 'error' : 'success',
        title: message,
        showConfirmButton: false,
        timer: 2200,
        timerProgressBar: true,
      });
      return;
    }

    if (window.$ && $.SystemScript && $.SystemScript.swalAlertMessage) {
      $.SystemScript.swalAlertMessage(type === 'error' ? 'Oops!' : 'Success', message, type);
      return;
    }

    alert(message);
  }

  if (typeof window !== 'undefined') {
    window.ZynToast = showToast;
  }

  init();
})();
