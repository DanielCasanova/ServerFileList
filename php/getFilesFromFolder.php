<?php
    $path = $_GET['path'];
    $dir = './topLevel/'.$path.'*';
    $type = $_GET['type'];

    if($type == 'folders')
    {
        $folders = glob($dir, GLOB_ONLYDIR);
        
        foreach($folders as &$f)
        { 
            $f = str_replace('./topLevel', '', $f); 
            $f = str_replace('/'.$path, '', $f);
        }

        echo json_encode($folders);
    }

    if($type == 'files')
    {
        $content = glob($dir);

        $files = array();
        foreach($content as $c)
        {
            if(is_file($c))
            { array_push($files, $c); }
        }

        foreach($files as &$f)
        { 
            $f = str_replace('./topLevel', '', $f); 
            $f = str_replace('/'.$path, '', $f);
        }
        
        echo json_encode($files);
    }
?>