<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
  
    <title>Waloria</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script>
      function OnSearch()
      {
        console.log("Searching");

        var name = document.getElementById("spellName").value;
        var level = document.getElementById("spellLevel").value;

        $.get('/php/spellsearch.php', {name: name, level: level}, function(data){
          console.log(data);
          document.getElementById("result").innerHTML = data;
        })
      }

    </script>
  </head>
  <body style="background-color:#2c3e50">
    <div class="col-md-6 col-md-offset-3">
      <nav class="navbar navbar-default">
      <div class="container-fluid">
        <div class="navbar-header">

          <a class="navbar-brand" href="http://forum.waloria.com">
            <p>Waloria</p>
          </a>
          <form class="navbar-form navbar-left" role="search">
            <div class="form-group">
              <input type="text" class="form-control" placeholder="Name" id="spellName" onkeyup="OnSearch()">
            </div>
            <div class="form-group">
              <input type="text" class="form-control" placeholder="Level" id="spellLevel" onkeyup="OnSearch()">
            </div>
            <!--<button type="submit" id="submit" class="btn btn-default" onclick="OnSearch()">Search</button>-->
          </form>

        </div>
      </div>
    </nav>

    <div class="panel panel-default">
      <!-- Default panel contents -->

      <!-- Table -->
      <table class="table table-hover">
        <thead>
          <tr>
            <th>Name</th>
            <th>Level</th>
            <th>Category</th>
          </tr>
        </thead>
        <tbody id="result">
        </tbody>
      </table>
    </div>
    </div>
    
    <script src="js/bootstrap.min.js"></script>
    <!--<script type="text/javascript">
      $('#submit').click(function(e) {
        console.log("SUBMIT")
        e.preventDefault();
        return false;
      });
    </script>-->
  </body>
</html>