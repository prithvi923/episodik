$(document).ready(function() {
  $('form.preferences').submit(function(e) {
    e.preventDefault();
    var form = $(this);
    var checked = $('form input[type=radio]:checked');
    var unchecked = $('form input[type=radio]:not(:checked)');
    if (checked.length != 10) {
      alert("You must compare 10 shows");
      return;
    } else {
      var ret = {},
          check = [],
          uncheck = [];
      for (var i = 0; i < checked.length; i++) {
        check[i] = checked[i].value;
        uncheck[i] = unchecked[i].value;
      }
      ret.checked = check;
      ret.unchecked = uncheck;
      routes = location.pathname.split("/");
      ret.user_id = routes[routes.length-1];
      $.ajax({
        url: form.attr('action'),
        type: form.attr('method'),
        data : ret,
        success: function(res) {
          if (res.code == 200) {
            location.pathname = '/users/' + ret.user_id;
          }
        }
      });
    }
    return false;
  });
});