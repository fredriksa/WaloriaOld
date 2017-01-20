<?php
?>
<!DOCTYPE HTML>
<html>
  <head>
    <title>Waloria | Waloria.com</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!--[if lte IE 8]><script src="assets/js/html5shiv.js"></script><![endif]-->
    <link rel="stylesheet" href="assets/css/main.css" />
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!--[if lte IE 9]><link rel="stylesheet" href="assets/css/ie9.css" /><![endif]-->
    <!--[if lte IE 8]><link rel="stylesheet" href="assets/css/ie8.css" /><![endif]-->
    <noscript><link rel="stylesheet" href="assets/css/noscript.css" /></noscript>
  </head>
  <body class="is-loading">

    <!-- Wrapper -->
      <div id="wrapper">

        <!-- Main -->
          <section id="main">
            <header>
              <span class="avatar"><img src="http://www.waloria.com/imgs/walorialogo.png" alt="" /></span>
              <h1>Waloria</h1>
              <p>Open Beta Classless Server</p>
            </header>
            
            <hr />
            <table class="table table-hover">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Level</th>
                  <th style="text-align:center">Race</th>
                </tr>
              </thead>
              <tbody id="result">
                <?php
                  include('include/players.php');
                ?>
              </tbody>
            </table>
              <ul class="actions">
                  <li style="width:100%"><a href="http://waloria.com/onlineplayers.php" class="button" style="width:100%">Refresh</a></li>
              </ul>
            <hr />
            
            <footer>
              <div>
                <ul class="actions">
                  <li style="width:100%"><a href="http://waloria.com" class="button" style="width:100%">Home</a></li>
                </ul>
                <div>
                  <ul class="actions">
                  <li style="width:100%"><a href="http://waloria.com/connectionguide.html" class="button" style="width:100%">Connection Guide</a></li>
                </ul>
                <ul class="actions">
                  <li style="width:100%"><a href="https://discord.gg/t74TxEG" class="button" style="width:100%">Join Discord</a></li>
                </ul>
              </div>
              
              <ul class="icons">
                <li><a href="http://forum.waloria.com" class="fa-commenting-o">Forum</a></li>
                <li><a href="http://youtube.com/zilva86" class="fa-youtube">Youtube</a></li>
                <li><a href="http://forum.waloria.com" class="fa-question">FAQ</a></li>
              </ul>
            </footer>
          </section>

        <!-- Footer -->
          <footer id="footer">
            <ul class="copyright">
              <li>Waloria</li><li><a href="http://waloria.com">Waloria.com</a></li>
            </ul>
          </footer>
      </div>

    <!-- Scripts -->
      <!--[if lte IE 8]><script src="assets/js/respond.min.js"></script><![endif]-->
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
      <script src="js/bootstrap.min.js"></script>
      <script>
        if ('addEventListener' in window) {
          window.addEventListener('load', function() { document.body.className = document.body.className.replace(/\bis-loading\b/, ''); });
          document.body.className += (navigator.userAgent.match(/(MSIE|rv:11\.0)/) ? ' is-ie' : '');
        }
      </script>

      <script>
        $("#submitRegister").click(function() {
          $("#register").submit();
          console.log("clicked");
        });

        $("#register").submit(function(e) {
          e.preventDefault();

          var form = $(this);
          var request = $.ajax({
            url: "include/register.php",
            type: "post",
            data: form.serialize(),
            success: function(data)
            {
              $("#registerStatus").text(data);
            }
          });

        })
      </script>

  </body>
</html>