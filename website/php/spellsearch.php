<?php
  $con = mysqli_connect("localhost", "root", "ascent", "world");

  if (mysqli_connect_errno())
  {
    echo "FAILED TO CONNECT MYSQL";
  }

  function getCategory($nr)
  {
    if ($nr == 1) {
      return "Damage";
    } elseif ($nr == 2) {
      return "Healing";
    } elseif ($nr == 3) {
      return "Buff";
    } elseif ($nr == 4) {
      return "Utility";
    }
  }

  function rowColor($category)
  {
    if ($category == 1) {
      return "danger"; //damage
    } elseif ($category == 2) {
      return "success"; //healing
    } elseif ($category == 3) {
      return "info"; //buff
    } elseif ($category == 4) {
      return "warning"; //utility
    }
  }

  function getIcon($category)
  {
    $icon = "";

    if ($category == 1) {
      $icon = "damage1.jpg"; //damage
    } elseif ($category == 2) {
      $icon = "heal1.jpg"; //healing
    } elseif ($category == 3) {
      $icon = "buff1.jpg"; //buff
    } elseif ($category == 4) {
      $icon = "utility1.jpg"; //utility
    }

    return "<img src='imgs/".$icon."'' alt=''>";
  }

  function executeStatement($statement)
  {
    $statement->execute();
    $result = $statement->get_result();
    while ($row = $result->fetch_assoc()) {
      echo "<tr>";
      echo "<td>".$row["name"]."</th>";
      echo "<td>".$row["level"]."</th>";
      echo "<td class=".rowColor((int)$row["category"]).">".getIcon((int)$row["category"])."    ".getCategory((int)$row["category"])."</th>";
      //echo $row["name"] . " " . $row["level"] . " " . $row["category"];
      echo "</tr>";
    }
  }

  $name = $_GET['name'];
  $level = $_GET['level'];

  $stmt1 = $con->prepare("SELECT custom_spell_system.spellName AS name, custom_spell_system.spellLevel AS level, category FROM custom_spell_system JOIN custom_spell_system_categories WHERE custom_spell_system.spellID=custom_spell_system_categories.spellID AND spellName LIKE(CONCAT('%',?,'%')) AND spellLevel<61 ORDER BY level ASC");

  $stmt2 = $con->prepare("SELECT custom_spell_system.spellName AS name, custom_spell_system.spellLevel AS level, category FROM custom_spell_system JOIN custom_spell_system_categories WHERE custom_spell_system.spellID=custom_spell_system_categories.spellID AND spellLevel=? AND spellLevel<61 ORDER BY level ASC");

  $stmt3 = $con->prepare("SELECT custom_spell_system.spellName AS name, custom_spell_system.spellLevel AS level, category FROM custom_spell_system JOIN custom_spell_system_categories WHERE custom_spell_system.spellID=custom_spell_system_categories.spellID AND spellName LIKE(CONCAT('%',?,'%')) AND spellLevel=? AND spellLevel<61 ORDER BY level ASC");

  if ($name != '' && $level == '')
  {
    $stmt1->bind_param('s', $name);
    executeStatement($stmt1);
  } elseif ($name == '' && $level != '')
  {
    $stmt2->bind_param('s', $level);
    executeStatement($stmt2);
  } elseif ($name != '' && $level != '')
  {
    $stmt3->bind_param('ss', $name, $level);
    executeStatement($stmt3);
  }
?>