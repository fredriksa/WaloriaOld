$('body').on('change', '#slot', function() {
  $.get("/item/subclasses/" + this.value, function(res) {
    var data = $.parseJSON(res);
    $('#subclass').empty();

    $(data).each(function() {
      var htmlString = "<option value='" + this.name + "''>" + this.name + "</option>"
      $('#subclass').append(htmlString);
    });

    console.log(data);
  });
});