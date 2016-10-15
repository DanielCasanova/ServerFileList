<?php
    $path = $_GET['path'];
    $dir = './topLevel/'.$path;

    $fInfo = array(pathinfo($dir)['extension'], filesize($dir), filemtime($dir));

    echo json_encode($fInfo);
?>