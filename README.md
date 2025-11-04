# Zyntra E-commerce Platform

A modern, responsive e-commerce platform built with Flask, MySQL, and Bootstrap 5.

## Features

### 🏠 Home Page
- **Banner Carousel**: Beautiful full-width rotating banners with high-quality product images
- **Modern Product Cards**: Click entire cards to view products (no add-to-cart buttons)
- **Clean Interface**: Minimalist design focusing on product discovery
- **Responsive Grid**: Products adapt perfectly to all screen sizes
- **Interactive Elements**: Wishlist and quick view buttons with smooth animations

### 🎨 Design Features
- **Modern UI**: Clean, professional design using Bootstrap 5
- **Responsive Layout**: Mobile-first design that works on all devices
- **Smooth Animations**: Hover effects and transitions
- **Interactive Elements**: Toast notifications and loading states

## Recent Updates

### ✨ Latest Updates
1. **Banner Carousel**: Full-width rotating banner images with optimized heights
2. **Modern Product Cards**: Entire cards are clickable (modern e-commerce approach)
3. **Clean Design**: Removed stats section and add-to-cart buttons for cleaner look
4. **Responsive Images**: `object-fit: contain` ensures full images are visible
5. **Interactive Elements**: Smooth hover effects and proper event handling

### 🔧 Technical Improvements
- **Event Delegation**: Cleaner JavaScript with event delegation
- **Meta Tags**: Authentication status available to JavaScript
- **Responsive Images**: Optimized carousel images for different screen sizes
- **Error Handling**: Better error handling in JavaScript functions

## Installation

1. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Database Setup**:
   - Ensure MySQL is running
   - Database name: `zyntra`
   - Import `database/zyntra1.sql` to set up tables and sample data

3. **Run Application**:
   ```bash
   python app/app.py
   ```

4. **Access**: Visit `http://localhost:5000`

## Database Structure

The application uses the following main tables:
- `products` - Product information
- `categories` - Product categories
- `product_attachments` - Product images
- `users` - User accounts
- `order_items` - Shopping cart items

## File Structure

```
Zyntra/
├── app/                    # Flask application
│   ├── app.py             # Main application
│   ├── routes.py          # URL routes
│   └── controller/        # Controllers
├── template/              # HTML templates
│   ├── base.html         # Base template
│   ├── views/home.html   # Home page
│   └── include/          # Reusable components
├── static/                # CSS, JS, images
│   └── css/custom.css    # Custom styles
└── database/             # Database files
    └── zyntra1.sql       # Database schema and data
```

## Customization

### Adding New Carousel Slides
Edit `template/views/home.html` and add new carousel slides:

```html
<div class="carousel-item">
  <div class="hero-banner">
    <img src="your-image-url.jpg" alt="Description" class="hero-banner-img">
  </div>
</div>
```

### Product Card Interaction
- **Clickable Cards**: Click anywhere on product cards to view product details
- **Button Actions**: Wishlist and quick view buttons work independently
- **Modern UX**: Clean, distraction-free shopping experience
- **Hover Effects**: Subtle animations provide visual feedback

## Browser Support
- Chrome (recommended)
- Firefox
- Safari
- Edge

## Contributing
1. Make changes to templates or CSS
2. Test on different screen sizes
3. Ensure JavaScript functionality works
4. Update this README if adding new features
