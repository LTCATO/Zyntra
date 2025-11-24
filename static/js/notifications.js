(function () {
    const NotificationCenter = {
        root: null,
        countBadge: null,
        listContainer: null,
        emptyState: null,
        markAllBtn: null,
        toggle: null,
        isLoading: false,
        hasLoaded: false,

        init() {
            this.root = document.querySelector('[data-notification-root]');
            if (!this.root || typeof axios === 'undefined') {
                return;
            }

            this.countBadge = this.root.querySelector('[data-notification-count]');
            this.listContainer = this.root.querySelector('[data-notification-list]');
            this.emptyState = this.root.querySelector('[data-notification-empty]');
            this.markAllBtn = this.root.querySelector('[data-notification-markall]');
            this.toggle = this.root.querySelector('[data-notification-toggle]');

            if (this.markAllBtn) {
                this.markAllBtn.addEventListener('click', (event) => {
                    event.preventDefault();
                    this.markAllRead();
                });
            }

            if (this.toggle) {
                this.toggle.addEventListener('click', () => {
                    if (!this.hasLoaded) {
                        this.loadNotifications();
                    }
                });

                this.toggle.addEventListener('shown.bs.dropdown', () => {
                    if (!this.hasLoaded || this.shouldRefresh) {
                        this.loadNotifications();
                    }
                });
            }

            this.listContainer?.addEventListener('click', (event) => {
                const button = event.target.closest('[data-notification-read]');
                if (!button) {
                    return;
                }
                const id = button.getAttribute('data-notification-read');
                if (id) {
                    event.preventDefault();
                    this.markSingleRead(id);
                }
            });

            // Initial fetch for badges even if dropdown isn't opened yet
            this.loadNotifications();
        },

        async loadNotifications() {
            if (this.isLoading) {
                return;
            }
            this.isLoading = true;
            this.setEmptyState('Loading notifications…');

            try {
                const response = await axios.get('/notifications');
                const payload = response?.data?.data || { items: [], unread_count: 0 };
                this.renderNotifications(payload.items || []);
                this.updateBadge(payload.unread_count || 0);
                this.hasLoaded = true;
                this.shouldRefresh = false;
            } catch (error) {
                console.error('Unable to load notifications', error);
                this.setEmptyState('Unable to load notifications right now.');
            } finally {
                this.isLoading = false;
            }
        },

        renderNotifications(items) {
            if (!this.listContainer) {
                return;
            }

            this.listContainer.innerHTML = '';

            if (!items.length) {
                this.setEmptyState('No new notifications');
                return;
            }

            this.setEmptyState('');

            const fragment = document.createDocumentFragment();
            items.forEach((item) => {
                const li = document.createElement('li');
                li.className = 'dropdown-item px-3 py-2 notification-item';

                const isUnread = !item.is_read;
                const reference = item.reference ? `<span class="text-primary fw-semibold">${item.reference}</span>` : '';

                li.innerHTML = `
                    <div class="d-flex flex-column gap-1 ${isUnread ? 'fw-semibold' : ''}">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div>${escapeHtml(item.title || 'Notification')}</div>
                                <small class="text-muted">${item.created_at_display || ''}</small>
                            </div>
                            ${isUnread ? `<button class="btn btn-link btn-sm p-0" data-notification-read="${item.notification_id}">Mark read</button>` : ''}
                        </div>
                        <div class="small text-body">${escapeHtml(item.message || '')} ${reference}</div>
                    </div>
                `;

                fragment.appendChild(li);
            });

            this.listContainer.appendChild(fragment);
        },

        async markSingleRead(notificationId) {
            try {
                await axios.post(`/notifications/read/${notificationId}`);
                this.shouldRefresh = true;
                this.loadNotifications();
            } catch (error) {
                console.error('Unable to mark notification as read', error);
            }
        },

        async markAllRead() {
            if (!this.markAllBtn) {
                return;
            }
            this.markAllBtn.disabled = true;
            try {
                await axios.post('/notifications/read/all');
                this.shouldRefresh = true;
                this.loadNotifications();
            } catch (error) {
                console.error('Unable to mark notifications as read', error);
            } finally {
                this.markAllBtn.disabled = false;
            }
        },

        updateBadge(unreadCount) {
            if (!this.countBadge) {
                return;
            }
            if (unreadCount > 0) {
                this.countBadge.textContent = unreadCount > 9 ? '9+' : unreadCount;
                this.countBadge.classList.remove('d-none');
            } else {
                this.countBadge.classList.add('d-none');
            }
        },

        setEmptyState(text) {
            if (!this.emptyState) {
                return;
            }
            if (!text) {
                this.emptyState.classList.add('d-none');
                this.emptyState.textContent = '';
                return;
            }
            this.emptyState.classList.remove('d-none');
            this.emptyState.textContent = text;
        }
    };

    function escapeHtml(str) {
        if (!str) return '';
        return str
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }

    document.addEventListener('DOMContentLoaded', () => NotificationCenter.init());
})();
