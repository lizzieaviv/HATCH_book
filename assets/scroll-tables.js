<script>
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("table").forEach(function (table) {
    // Scroll setup
    table.style.display = "block";
    table.style.overflowX = "auto";
    table.style.whiteSpace = "nowrap";
    table.style.width = "max-content";
    table.style.maxWidth = "100%";

    // Capitalize 'value' and 'label' headers
    table.querySelectorAll("th").forEach(function (th) {
      const text = th.textContent.trim().toLowerCase();
      if (text === "value" || text === "label") {
        th.textContent = text.charAt(0).toUpperCase() + text.slice(1);
      }
    });

    // Center any cell with no space
    table.querySelectorAll("td").forEach(function (td) {
      const text = td.textContent.trim();
      if (!text.includes(" ")) {
        td.style.textAlign = "center";
      }
    });
  });
});
</script>