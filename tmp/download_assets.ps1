$baseUrlBootstrap = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist"
$baseUrlFontAwesome = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0"

# Bootstrap
Invoke-WebRequest -Uri "$baseUrlBootstrap/css/bootstrap.min.css" -OutFile "Content/bootstrap.min.css"
Invoke-WebRequest -Uri "$baseUrlBootstrap/js/bootstrap.bundle.min.js" -OutFile "Scripts/bootstrap.bundle.min.js"

# FontAwesome CSS
Invoke-WebRequest -Uri "$baseUrlFontAwesome/css/all.min.css" -OutFile "Content/font-awesome/all.min.css"

# FontAwesome WebFonts
$fonts = @("fa-solid-900.woff2", "fa-regular-400.woff2", "fa-brands-400.woff2", "fa-v4compatibility.woff2")
foreach ($font in $fonts) {
    Invoke-WebRequest -Uri "$baseUrlFontAwesome/webfonts/$font" -OutFile "Content/webfonts/$font"
}

# Poppins Font (using a simplified approach since Google Fonts is dynamic)
# I will download 300, 400, 600 from a direct source or use a CSS file that maps to them.
# For simplicity, I'll use a local CSS that points to the fonts once I download them.
