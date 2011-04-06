jqueryMatchers = {
  toBeVisible: function() {
    return $(this.actual).is(':visible');
  },

  toBeDisabled: function() {
    return $(this.actual).is(':disabled');
  },

  toBeEmpty: function(){
    return $(this.actual).html() == "";
  },

  toBeChecked : function() {
    return $(this.actual).is(':checked');
  },

  toHaveClass : function(klass) {
    return $(this.actual).hasClass(klass);
  },

  toHaveAttr: function(attr) {
    return $(this.actual).attr(attr) != undefined;
  },

  toBeReadOnly: function() {
    return $(this.actual).attr('readonly');
  },

  toExist : function() {
    return $(this.actual).length > 0;
  },

  toBeBlank: function() {
    return $(this.actual).val() == "";
  },

  toBeSingleton: function(matcher) {
    return $(this.actual).length == 1;
  }
};