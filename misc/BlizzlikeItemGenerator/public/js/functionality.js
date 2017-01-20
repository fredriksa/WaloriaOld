//Scrolls to element
function scrollTo(element) {
  $('html, body').animate({
    scrollTop: $(element).offset().top
  }, 2000);  
}

function globalStatCount() {
  var baseStats = $('.stats').length;
  var randomStats = $('.rstats').length;

  return baseStats + randomStats;
}

//Adds select to element with label and inner html text
function addSelect(element, label, inner) {
  var i = $('.' + element).length + 1;
  var labelI = label + i.toString();
  var inner = inner + ' ' + i.toString();

  var statSelect = ""

  $.get("stats", function(response) {
    var data = $.parseJSON(response);

    statSelect += "<div class='form-group'>" 
    // Label
    + "<label class='col-lg-4 control-label' placeholder='"+ inner + "'"
    + " name='" + labelI + "' style='text-align:center'>" + inner +"</label>"
    // Col lg 8
    + "<div class='col-lg-8'>"
    // Select
    + "<select id='select" + labelI + "' class='form-control " + element + "' name='" + labelI + "'>"
    + "<option value='none'>None</option>"
    $(data).each(function() {
      statSelect += "<option value='" + this.name + "'>" + this.name + "</option>"
    });

    statSelect += "</select>"
    + "</div>"
    + "</div>"

    $('#' + element).append(statSelect);
    scrollTo("#select" + labelI);
  });
}


$('body').on('change', '.stats', function() {
  if (globalStatCount() + 1 > 10) {
    return false;
  }

  addSelect('stats', 'stat', 'Stat');
});

$('body').on('change', '.rstats', function() {
  if (globalStatCount() + 1 > 10) {
    return false;
  }

  addSelect('rstats', 'rstat', 'Random Stat');
});

$('body').on('change', '#slot', function() {
  $.get("/subclasses/" + this.value, function(res) {
    var data = $.parseJSON(res);
    $('#subclass').empty();

    $(data).each(function() {
      var htmlString = "<option value='" + this.name + "''>" + this.name + "</option>"
      $('#subclass').append(htmlString);
    });

    console.log(data);
  });
});







