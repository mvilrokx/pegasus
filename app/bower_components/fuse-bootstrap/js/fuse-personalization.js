function rgb2hex(rgb) {
  if (  rgb.search("rgb") == -1 ) {
    return rgb;
  } else {
    rgb = rgb.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+))?\)$/);
    function hex(x) {
      return ("0" + parseInt(x).toString(16)).slice(-2);
    }
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
  }
}

var colorInputs = function (el, cssProp) {
  var $colorInputs = $('<div/>');
  var cssValue = el.css(cssProp);
  var $input;
  var index = 0;
  var color_re = /((?:#(?:[A-F0-9]){3}(?:(?:[A-F0-9]){3})?)|(?:rgba?\(\d+,\s*\d+,\s*\d+(?:,\s*(\d+))?\))|(?:transparent)|(?:aqua)|(?:black)|(?:blue)|(?:fuchsia)|(?:gray)|(?:green)|(?:lime)|(?:maroon)|(?:navy)|(?:olive)|(?:orange)|(?:purple)|(?:red)|(?:silver)|(?:teal)|(?:white)|(?:yellow))/gi;
  while (color = color_re.exec(cssValue)){
    $input = $('<input />', {id: 'customizable-' + el.get(0).tagName.toLowerCase() + '-' + el.attr('class') + '-' + cssProp + '-' + index, type: "color"})
      .val(rgb2hex(color[1]))
      .add('<br />')
      .on('change', {color: color, color_re_lastindex: color_re.lastIndex}, function(event){
        el.css(cssProp, cssValue.substring(0,event.data.color.index) + $(this).val() + cssValue.substring(event.data.color_re_lastindex,cssValue.length));
      });
    $colorInputs.append($input);
    index++;
  }
  return $colorInputs;
};

var scalarInputs = function (el, cssProp) {
  var $scalarInputs = $('<div/>');
  var cssValue = el.css(cssProp);
  var $input;
  var index = 0;
  var scalar_re = /([0-9\.]+)(%|in|cm|mm|em|ex|pt|pc|px)+/gi;
  while (scalar = scalar_re.exec(cssValue)){
    $input = $('<input />', {id: 'customizable-' + el.get(0).tagName.toLowerCase() + '-' + el.attr('class') + '-' + cssProp + '-' + index, type: "range"})
      .val((scalar[1]))
      .add('<br />')
      .on('change', {scalar: scalar, scalar_re_lastindex: scalar_re.lastIndex}, function(event){
        el.css(cssProp, cssValue.substring(0,event.data.scalar.index) + $(this).val() + event.data.scalar[2] + cssValue.substring(event.data.scalar_re_lastindex,cssValue.length));
      });
    $scalarInputs.append($input);
    index++;
  }
  return $scalarInputs;
};

$('*[data-customizable]').each(function(index){
  var $that = $(this);
  var legend = $('<legend></legend>').text($that.get(0).tagName.toLowerCase() + '.' + $that.attr('class'));
  var fieldset = $('<fieldset></fieldset>').append(legend);
  $.each($that.data('customizable'), function(index, cssProp){
    fieldset.append('<label>' + cssProp + '</label>');
    fieldset.append(colorInputs($that, cssProp));
    fieldset.append(scalarInputs($that, cssProp));
  });
  fieldset.appendTo('#customizations-form');
});