(function (window, document) {
  const API_BASE = '/api/rider/pickups';

  function createPickupCard(data, scope) {
    const isAvailable = scope === 'available';
    const actions = [];

    if (isAvailable) {
      actions.push(
        `<button class="btn btn-sm btn-primary" data-action="claim" data-id="${data.suborder_id}">Claim Pickup</button>`
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

    const statusBadge = buildStatusBadge(data.pickup_status);
    return `
      <div class="list-group-item">
        <div class="d-flex justify-content-between align-items-start">
          <div>
            <h6 class="mb-1">Order ${data.order_reference || data.sub_reference}</h6>
            <p class="mb-1 small text-muted">Seller: ${escapeHtml(data.seller_store || 'Seller')}</p>
            <p class="mb-1 small">Drop-off: ${escapeHtml(data.buyer_name || 'Buyer')} ${data.buyer_phone ? `&middot; ${data.buyer_phone}` : ''}</p>
            <div>${statusBadge}</div>
          </div>
          <div class="d-flex flex-column gap-2">
            ${actions.join('<div></div>') || '<span class="badge bg-secondary">Awaiting update</span>'}
          </div>
        </div>
      </div>`;
  }

  function buildStatusBadge(status) {
    const labels = {
      0: ['secondary', 'Pending Fulfillment'],
      1: ['info', 'Awaiting Pickup'],
      2: ['primary', 'Claimed'],
      3: ['warning', 'In Transit'],
      4: ['success', 'Delivered'],
    };
    const [variant, text] = labels[status] || ['secondary', 'Unknown'];
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
