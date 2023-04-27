<?php

function userType($val)
{
    switch ($val) {
        case '1':
            return "Super Admin";
            break;
        case '2':
            return "Admin";
            break;
        case '3':
            return "User";
            break;
        default:
            return "";
            break;
    }
}

?>