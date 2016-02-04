if (typeof Chart !== "undefined") {
  Chart.defaults.global.customTooltips = function(tooltip) {
    // Tooltip Element
    var tooltipEl = $('#chartjs-tooltip');
    if (!tooltipEl[0]) {
      $('body').append('<div id="chartjs-tooltip"></div>');
      tooltipEl = $('#chartjs-tooltip');
    }
    // Hide if no tooltip
    if (!tooltip.opacity) {
      tooltipEl.css({
        opacity: 0
      });
      $('.chartjs-wrap canvas')
        .each(function(index, el) {
          $(el).css('cursor', 'default');
        });
      return;
    }
    $(this._chart.canvas).css('cursor', 'pointer');
    // Set caret Position
    tooltipEl.removeClass('above below no-transform');
    if (tooltip.yAlign) {
      tooltipEl.addClass(tooltip.yAlign);
    } else {
      tooltipEl.addClass('no-transform');
    }
    // Set Text
    if (tooltip.body) {
      var innerHtml = [
        (tooltip.beforeTitle || []).join('\n'), (tooltip.title || []).join('\n'), (tooltip.afterTitle || []).join('\n'), (tooltip.beforeBody || []).join('\n'), (tooltip.body || []).join('\n'), (tooltip.afterBody || []).join('\n'), (tooltip.beforeFooter || [])
        .join('\n'), (tooltip.footer || []).join('\n'), (tooltip.afterFooter || []).join('\n')
      ];
      tooltipEl.html(innerHtml.join('\n'));
    }
    // Find Y Location on page
    var top = 0;
    if (tooltip.yAlign) {
      if (tooltip.yAlign == 'above') {
        top = tooltip.y - tooltip.caretHeight - tooltip.caretPadding;
      } else {
        top = tooltip.y + tooltip.caretHeight + tooltip.caretPadding;
      }
    }
    if (isNaN(top)) {
      top = 0;
    }
    var offset = $(this._chart.canvas).offset();
    var left = offset.left + tooltip.x;
    if (left < 0) {
      left = offset.left;
    }
    // Display, position, and set styles for font
    tooltipEl.css({
      opacity: 1,
      width: tooltip.width ? (tooltip.width + 'px') : 'auto',
      left: left + 'px',
      top: offset.top + top + 'px',
      fontFamily: tooltip._fontFamily,
      fontSize: tooltip.fontSize,
      fontStyle: tooltip._fontStyle,
      padding: tooltip.yPadding + 'px ' + tooltip.xPadding + 'px',
    });
  };
}
