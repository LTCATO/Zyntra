(function (window, document) {
  const API_BASE = '/api/rider/pickups';

  function createPickupCard(data, scope) {
    const isAvailable = scope === 'available';
    const actions = [];

    if (isAvailable) {
      const orderRef = data.order_reference || data.sub_reference || '';
      actions.push(
        `<button class="btn btn-sm btn-primary" data-action="claim" data-id="${data.suborder_id}"
            data-order-ref="${escapeHtml(orderRef)}"
            data-sub-ref="${escapeHtml(data.sub_reference || '')}"
            data-seller="${escapeHtml(data.seller_store || 'Seller')}"
            data-buyer-name="${escapeHtml(data.buyer_name || 'Buyer')}"
            data-buyer-phone="${escapeHtml(data.buyer_phone || '')}">
           Claim Pickup
         </button>`
      );
    } else if (data.pickup_status === 2) {
      actions.push(
        `<button class="btn btn-sm btn-warning" data-action="move-status" data-status="3" data-id="${data.suborder_id}">Mark as In Transit</button>`
      );
    }

    if (!isAvailable && data.pickup_status >= 3 && data.pickup_status < 4) {
      actions.push(
        `<button class="btn btn-sm btn-success" data-action="move-status" data-status="4" data-id="${data.suborder_id}">Mark Delivered</button>`
      );
    }

    const statusBadge = buildStatusBadge(data.pickup_status, data.status);

    const actionContent = actions.join('<div></div>');
    const tailBadge = actionContent || (
      data.status === 6
        ? '<span class="badge bg-label-success">Completed</span>'
        : '<span class="badge bg-secondary">Awaiting update</span>'
    );
    return `
      <div class="list-group-item" data-scope="${scope}" data-suborder-id="${data.suborder_id}">
        <div class="d-flex justify-content-between align-items-start">
          <div>
            <h6 class="mb-1">Order ${data.order_reference || data.sub_reference}</h6>
            <p class="mb-1 small text-muted">Seller: ${escapeHtml(data.seller_store || 'Seller')}</p>
            <p class="mb-1 small">Drop-off: ${escapeHtml(data.buyer_name || 'Buyer')} ${data.buyer_phone ? `&middot; ${data.buyer_phone}` : ''}</p>
            <div>${statusBadge}</div>
          </div>
          <div class="d-flex flex-column gap-2">
            ${tailBadge}
          </div>
        </div>
      </div>`;
  }

  function buildStatusBadge(pickupStatus, orderStatus) {
    if (orderStatus === 6) {
      return '<span class="badge bg-label-success">Completed</span>';
    }

    const labels = {
      0: ['secondary', 'Pending Fulfillment'],
      1: ['info', 'Awaiting Pickup'],
      2: ['primary', 'Claimed'],
      3: ['warning', 'In Transit'],
      4: ['success', 'Delivered'],
    };
    const [variant, text] = labels[pickupStatus] || ['secondary', 'Unknown'];
    return `<span class="badge bg-label-${variant}">${text}</span>`;
  }

  function escapeHtml(value) {
    if (typeof value !== 'string') return value || '';
    return value
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  function attachActionHandlers(container) {
    container.querySelectorAll('[data-action="claim"]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const suborderId = btn.dataset.id;
        if (!suborderId) return;

        const modalEl = document.getElementById('riderClaimConfirmModal');
        if (!modalEl || !window.bootstrap || !window.bootstrap.Modal) {
          // Fallback: no modal available, behave as before
          setButtonLoading(btn, true);
          fetch(`${API_BASE}/${suborderId}/claim`, { method: 'POST' })
            .then((res) => res.json())
            .then((data) => {
              if (data.status === 'success') {
                refreshLists();
              } else {
                alert(data.message || 'Unable to claim pickup.');
              }
            })
            .catch(() => alert('Network error while claiming pickup.'))
            .finally(() => setButtonLoading(btn, false));
          return;
        }

        // Populate modal with basic details
        modalEl.querySelector('[data-claim="order-ref"]').textContent = btn.dataset.orderRef || btn.dataset.subRef || suborderId;
        modalEl.querySelector('[data-claim="sub-ref"]').textContent = btn.dataset.subRef || '-';
        modalEl.querySelector('[data-claim="seller"]').textContent = btn.dataset.seller || 'Seller';
        modalEl.querySelector('[data-claim="buyer"]').textContent = btn.dataset.buyerName || 'Buyer';
        modalEl.querySelector('[data-claim="buyer-phone"]').textContent = btn.dataset.buyerPhone || 'N/A';

        const confirmBtn = modalEl.querySelector('[data-claim="confirm"]');
        const cancelBtn = modalEl.querySelector('[data-claim="cancel"]');
        const bsModal = window.bootstrap.Modal.getOrCreateInstance(modalEl);

        function cleanup() {
          if (confirmBtn) confirmBtn.removeEventListener('click', onConfirm);
          if (cancelBtn) cancelBtn.removeEventListener('click', onCancel);
        }

        function onCancel() {
          cleanup();
          bsModal.hide();
        }

        function onConfirm() {
          cleanup();
          bsModal.hide();
          setButtonLoading(btn, true);
          fetch(`${API_BASE}/${suborderId}/claim`, { method: 'POST' })
            .then((res) => res.json())
            .then((data) => {
              if (data.status === 'success') {
                refreshLists();
              } else {
                alert(data.message || 'Unable to claim pickup.');
              }
            })
            .catch(() => alert('Network error while claiming pickup.'))
            .finally(() => setButtonLoading(btn, false));
        }

        if (confirmBtn) confirmBtn.addEventListener('click', onConfirm);
        if (cancelBtn) cancelBtn.addEventListener('click', onCancel);

        bsModal.show();
      });
    });

    container.querySelectorAll('[data-action="move-status"]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const suborderId = btn.dataset.id;
        const status = btn.dataset.status;
        if (!suborderId || !status) return;
        setButtonLoading(btn, true);
        const formData = new FormData();
        formData.append('status', status);
        fetch(`${API_BASE}/${suborderId}/status`, { method: 'POST', body: formData })
          .then((res) => res.json())
          .then((data) => {
            if (data.status === 'success') {
              refreshLists();
            } else {
              alert(data.message || 'Unable to update status.');
            }
          })
          .catch(() => alert('Network error while updating status.'))
          .finally(() => setButtonLoading(btn, false));
      });
    });

    container.querySelectorAll('.list-group-item[data-scope="mine"]').forEach((item) => {
      item.addEventListener('click', (event) => {
        if (event.target.closest('[data-action]')) {
          return;
        }

        const suborderId = item.getAttribute('data-suborder-id');
        if (!suborderId) return;

        const modalEl = document.getElementById('riderAssignmentDetailModal');
        if (!modalEl || !window.bootstrap || !window.bootstrap.Modal) {
          return;
        }

        const bodyEl = modalEl.querySelector('[data-detail="body"]');
        if (bodyEl) {
          bodyEl.innerHTML = '<div class="text-center py-4 text-muted small">Loading details...</div>';
        }

        const bsModal = window.bootstrap.Modal.getOrCreateInstance(modalEl);
        bsModal.show();

        fetch(`${API_BASE}/${suborderId}/details`)
          .then((res) => res.json())
          .then((data) => {
            if (data.status !== 'success' || !data.data) {
              throw new Error(data.message || 'Unable to load details');
            }
            renderAssignmentDetail(modalEl, data.data);
          })
          .catch(() => {
            if (bodyEl) {
              bodyEl.innerHTML = '<div class="text-center py-4 text-danger small">Unable to load details at the moment.</div>';
            }
          });
      });
    });
  }

  function renderAssignmentDetail(modalEl, detail) {
    if (!modalEl) return;

    const orderRefEl = modalEl.querySelector('[data-detail="order-ref"]');
    const subRefEl = modalEl.querySelector('[data-detail="sub-ref"]');
    const buyerNameEl = modalEl.querySelector('[data-detail="buyer-name"]');
    const buyerPhoneEl = modalEl.querySelector('[data-detail="buyer-phone"]');
    const buyerAddressEl = modalEl.querySelector('[data-detail="buyer-address"]');
    const sellerStoreEl = modalEl.querySelector('[data-detail="seller-store"]');
    const itemsRoot = modalEl.querySelector('[data-detail="items"]');

    if (orderRefEl) orderRefEl.textContent = detail.order_reference || '-';
    if (subRefEl) subRefEl.textContent = detail.sub_reference || '-';
    if (buyerNameEl) buyerNameEl.textContent = detail.buyer_name || 'Buyer';
    if (buyerPhoneEl) buyerPhoneEl.textContent = detail.buyer_phone || 'N/A';
    if (buyerAddressEl) buyerAddressEl.textContent = detail.buyer_address || 'No address on file';
    if (sellerStoreEl) sellerStoreEl.textContent = detail.seller_store || detail.seller_name || 'Seller';

    if (!itemsRoot) return;

    const items = detail.items || [];
    if (!items.length) {
      itemsRoot.innerHTML = '<div class="text-muted small">No items found for this sub-order.</div>';
      return;
    }

    const rows = items
      .map((item) => {
        const qty = item.quantity || 0;
        const unit = item.unit_price || 0;
        const total = item.line_total || qty * unit;
        const priceText = `₱${Number(unit).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
        const totalText = `₱${Number(total).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
        const image = item.product_image
          ? `<div class="me-3 flex-shrink-0" style="width: 48px; height: 48px; overflow: hidden; border-radius: 0.5rem; background:#f8f9fa;"><img src="${item.product_image}" alt="${escapeHtml(
              item.product_name || ''
            )}" class="img-fluid h-100 w-100 object-fit-cover"></div>`
          : '';

        return `
          <div class="d-flex align-items-center mb-3">
            ${image}
            <div class="flex-grow-1">
              <div class="fw-semibold small mb-1">${escapeHtml(item.product_name || '')}</div>
              <div class="d-flex justify-content-between small text-muted">
                <span>Qty: ${qty}</span>
                <span>Unit: ${priceText}</span>
                <span>Total: ${totalText}</span>
              </div>
            </div>
          </div>`;
      })
      .join('');

    itemsRoot.innerHTML = rows;
  }

  function setButtonLoading(button, isLoading) {
    if (!button) return;
    if (isLoading) {
      button.dataset.originalText = button.innerHTML;
      button.setAttribute('disabled', 'disabled');
      button.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';
    } else {
      button.innerHTML = button.dataset.originalText || button.innerHTML;
      button.removeAttribute('disabled');
    }
  }

  function renderPickupList(scope, pickups) {
    const listEl = document.querySelector(`[data-pickup-list="${scope}"]`);
    const countEl = document.querySelector(`[data-rider-count="${scope}"]`);
    if (!listEl) return;

    if (!pickups.length) {
      listEl.innerHTML = `<div class="text-center py-4 text-muted small">${scope === 'available' ? 'No pickups waiting right now.' : 'No active assignments.'}</div>`;
      if (countEl) countEl.textContent = '0';
      return;
    }

    listEl.innerHTML = pickups.map((item) => createPickupCard(item, scope)).join('');
    if (countEl) countEl.textContent = pickups.length;
    attachActionHandlers(listEl);
  }

  function fetchPickupScope(scope) {
    const params = new URLSearchParams({ scope });
    return fetch(`${API_BASE}?${params.toString()}`)
      .then((res) => res.json())
      .then((data) => {
        if (data.status !== 'success') {
          throw new Error(data.message || 'Failed to fetch pickups');
        }
        return data.data || [];
      });
  }

  function refreshLists() {
    Promise.all([fetchPickupScope('available'), fetchPickupScope('mine')])
      .then(([available, mine]) => {
        renderPickupList('available', available);
        renderPickupList('mine', mine);
      })
      .catch((err) => {
        console.error(err);
        alert('Unable to load rider pickups at the moment.');
      });
  }

  document.addEventListener('DOMContentLoaded', function () {
    const root = document.getElementById('riderPickupRoot');
    if (!root) return;
    refreshLists();
  });
})(window, document);
