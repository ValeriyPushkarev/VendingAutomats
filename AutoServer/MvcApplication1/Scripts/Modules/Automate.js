
function updateAutomate(sender) {
    var obj = {};

    var name = $(sender).attr("automateName");

    var Name = $("#Name[automateName='" + name + "']").val();
    var Address = $("#Address[automateName='" + name + "']").val();
    var Desc = $("#Desc[automateName='" + name + "']").val();

    obj.Name = Name;
    obj.Address = Address;
    obj.Desc = Desc;

    jQuery.post('/Automates/Params', obj);
}

jQuery(document).ready(function () 
{
    $(".tabsvisible").tabs();
});
