// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

function validateFiles(inputFile) {
  var maxExceededMessage = "This file exceeds the maximum allowed file size (32 MB)";
  var extErrorMessage = "Only EXE file with extension: .exe is allowed";
  var allowedExtension = ["exe"];
  
  var extName;
  var maxFileSize = $(inputFile).data('max-file-size');
  var sizeExceeded = false;
  var extError = false;
  
  $.each(inputFile.files, function() {
    if (this.size && maxFileSize && this.size > parseInt(maxFileSize)) {sizeExceeded=true;};
    extName = this.name.split('.').pop();
    if ($.inArray(extName, allowedExtension) == -1) {extError=true;};
  });
  if (sizeExceeded) {
    window.alert(maxExceededMessage);
    $(inputFile).val('');
  };
  
  if (extError) {
    window.alert(extErrorMessage);
    $(inputFile).val('');
  };
}

function checker(){
  var inputs = document.getElementsByName("task[vms][]");
    var filter = document.getElementById("filter");
  var select1 = document.getElementById("select1");
  var select2 = document.getElementById("select2");
  var sel1 = parseInt(select1.value);
  var sel2 = parseInt(select2.value);
  tmp=0;
  $( ".num" ).remove();
  for (var i = 0; i < inputs.length; i++) {
    if (inputs[i].checked == true)
      tmp++;
  }
  output = "<h4 class='num'>" + tmp + "</h4>"
  $( "#number" ).append(output);
  flag=0;
  for (var i=0; i < inputs.length; i++){
    if (inputs[i].id >= sel1 && inputs[i].id <= sel2){
      if (inputs[i].checked != true){
        flag++;
      }
    }
  }
  if (flag == 0){
    filter.checked = true;
  }
  else{
    filter.checked = false;
  }
}
/*
function validateForm(params){
  var div = document.getElementById("textfield");
  var message = "";
  var elems = document.getElementsByName('task[vms][]');
  var count = 0;
  var field = document.getElementById("textfield3");
  if (document.getElementById("check_field").checked == true){
    if (isNaN(field.value)) {
        alert('Timeout field can contain only numeric');
        return false;
      }
    if (field.value < 0) {
        alert('Timeout should be positive');
        return false;
      }
    }
    else document.getElementById("textfield3").value = 0;


  for (var i = 0; i <= elems.length-1; i++) {
	var elem = document.getElementById(i);
  	if (elems[i].checked == true)
      count++;
    }
  if(div.value == "" || count == 0)// || document.getElementById("filefield").value == "")
  	{
  		if(div.value == ""){
        message += "Enter task name, please.\n";
      }
  		if(count == 0){
        message += "VMs was not checked.\n";
      }
  		if(document.getElementById("filefield").value  == "" && 
         document.getElementById("textfield2").value == ""){
        message += "File not chosen and command line is specified.\n";
      }
  		alert(message);
  		return false;
    }
  else 
    if(document.getElementById("filefield").value  == "" && 
       document.getElementById("textfield2").value == ""){
        message += "File not chosen and command line is specified.\n";
          alert(message);
        return false;
      }
  else return true;
}
*/
function validateForm(params){
  var taskname = document.getElementById("task_name");
  var vms = document.getElementsByName('task[vms][]');
  var timeout = document.getElementById("task_timeout");
  var cmd = document.getElementById("task_cmd");
  var file = document.getElementById("task_file");
  var vmss = document.getElementsByName('vmss');
  var count = 0;
  var message = "";

  if (document.getElementById("checktimeout_").checked == true){
    if (isNaN(timeout.value)) {
      message += "Timeout field can contain only numeric\n";
      document.getElementById("task_timeout").value = 0;
      document.getElementById("timeout").className = "input-group has-error";
    }
    else{
      document.getElementById("timeout").className = "input-group has-success";
    }
    if (timeout.value < 0) {
      message += "Timeout should be positive\n";
      document.getElementById("task_timeout").value = 0;
      document.getElementById("timeout").className = "input-group has-error";
    }
    else{
      document.getElementById("timeout").className = "input-group has-success";
    }
  }
  else document.getElementById("task_timeout").value = 0;

  for (var i = 0; i <= vms.length-1; i++) {
    if (vms[i].checked == true){
      vmss[i].className = "success"
      count++;
    }
    else{
      vmss[i].className = "warning"
    }
  }
  if (count == 0){
    for (var i = 0; i <= vmss.length-1; i++) {
      vmss[i].className = "danger"
    }
    message += "VMs was not checked\n";
  }

  if ($.trim(taskname.value) == ""){
    message += "Task name is null\n";
    document.getElementById("taskname").className = "input-group has-error";
  }
  else{
    document.getElementById("taskname").className = "input-group has-success";
  }

  if ($.trim(cmd.value) == ""){
    document.getElementById("comd").className = "input-group has-warning";
    document.getElementById("files").className = "input-group has-success";
    if (!file.value){
      document.getElementById("comd").className = "input-group has-error";
      document.getElementById("files").className = "input-group has-error";
      message += "File was not chosen or CMD is null\n";
    }
  }
  else {
    document.getElementById("files").className = "input-group has-success";
    document.getElementById("comd").className = "input-group has-success";
    if (!file.value){
      document.getElementById("comd").className = "input-group has-success";
      document.getElementById("files").className = "input-group has-warning";
    }
  }

  if(message == ""){
  }
  else{
    //alert(message);
    return false;
  }
}


function enable_timeout(check){
  if (document.getElementById("checktimeout_").checked == true)
      document.getElementById("task_timeout").disabled = false;
  else
      document.getElementById("task_timeout").disabled = true;
}

/*
function up(key){
  alert("up" + key + "");
  submitForm("pending");
}
*/
/*
function down(key){
  alert("down" + key + "");

}
*/

function addemail(param){
  var email = document.getElementsByName("task[email][]");
  var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    if(re.test(param.value) == true){
      output = "<div class='input-group' name='dynamic'>";
      output += "<input type='text' name='task[email][]' multiple='multiple' onchange='addemail(this)' class='form-control' id='task_email' placeholder='example@gmail.com'>";
      output += "<span class='input-group-addon'>Email</span>";
      output += "</div>";
      $( "#email" ).append(output);
      param.parentNode.className = "input-group has-success";
    }
    else{
      param.value = null;
      param.parentNode.className = "input-group has-error";
    }
    for (var i=0; i<email.length-1; i++) {
      if(re.test(email[i].value) != true){
        if(i<=email.length-1){
          email[i].parentNode.remove();
        }
      }
    }
}

function addfile(param){
  var file = document.getElementsByName("task[file]");
  if (file.length < 5){

    output = "<div id='emaildiv' class='input-group' name='dynamicadd'>";
    output += "<input accept='' class='form-control' data-max-file-size='33554432' id='task_file' name='task[file]' type='file' multiple='multiple'>";
    output += "<span class='input-group-addon'>";
    output += "<a name='arrow' type='button' onclick='delfile(this);' value='del'>delete</a></span>";
    output += "</div>";
    $( "#filer" ).append(output);
   }
}

function delfile(param){
  var file = document.getElementsByName("task[file]");
  param.parentNode.parentNode.remove();
}

function filtero(param){
  var inputs = document.getElementsByName("task[vms][]");
  var arch = document.getElementsByName("group1");
  var edition = document.getElementsByName("group2");
  var select1 = document.getElementById("select1");
  var select2 = document.getElementById("select2");
  var sel1 = parseInt(select1.value);
  var sel2 = parseInt(select2.value);
  var filter = document.getElementById("filter");
  var value1 = "custom";
  var value2 = "custom";
  for (var i=0; i<arch.length; i++){
    if (arch[i].checked == true){
      value1 = arch[i].value;
    }
  }
  for (var i=0; i<edition.length; i++){
    if (edition[i].checked == true){
      value2 = edition[i].value;
    }
  }

  if (param.value == "checkall"){
    for (i=0; i<inputs.length; i++){
      if (inputs[i].id >= sel1 && inputs[i].id <= sel2){
        if (param.checked == true){
            inputs[i].checked = true;
            for(var j=0; j<arch.length; j++){
              if (arch[j].value == " ")
                arch[j].checked = true;
              else
                arch[j].checked = false;
              if (edition[j].value == " ")
                edition[j].checked = true;
              else
                edition[j].checked = false;
            }
        }
        else{
          inputs[i].checked = false;
          for(var j=0; j<arch.length; j++){
              if (arch[j].value == "custom")
                arch[j].checked = true;
              else
                arch[j].checked = false;
              if (edition[j].value == "custom")
                edition[j].checked = true;
              else
                edition[j].checked = false;
            }
        }
      }
      else{
        inputs[i].checked = false;
      }
    }
  }
  else{
    for(var i=0; i<inputs.length; i++){
      if (inputs[i].id >= sel1 && inputs[i].id <= sel2){
        if (value1 != "custom" || value2 != "custom"){
          if (value1 == " " && value2 == " "){
            filter.checked = true;
            inputs[i].checked = true;
          }
          else
          if (value1 != "custom" && value2 != "custom"){
              filter.checked = false;
              if (value2 == "desktop"){
                if ( (inputs[i].value.indexOf(value1) != -1) &&
                     (inputs[i].value.indexOf("server") == -1) )
                  inputs[i].checked = true;
                else                         
                  inputs[i].checked = false;
              }
              else if ( (inputs[i].value.indexOf(value1) != -1) &&
                   (inputs[i].value.indexOf(value2) != -1) )
                inputs[i].checked = true;
              else                         
                inputs[i].checked = false;
          }
          else
          if (value1 == "custom" && value2 != "custom"){
            filter.checked = false;
              if (value2 == "desktop"){
                if ( inputs[i].value.indexOf("server") == -1)
                  inputs[i].checked = true;
                else                         
                  inputs[i].checked = false;
              }
              else
              if (inputs[i].value.indexOf(value2) != -1)
                inputs[i].checked = true;
              else                         
                inputs[i].checked = false;
          }
          else
          if (value1 != "custom" && value2 == "custom"){
            filter.checked = false;
              if (inputs[i].value.indexOf(value1) != -1)
                inputs[i].checked = true;
              else                         
                inputs[i].checked = false;
          }
          else {
            filter.checked = false;
          }
        }
      }
      else{
        inputs[i].checked = false;
      }
    }
  }
  checker();
  for (var i=0; i<select1.value; i++) {
    select2.options[i].disabled = true;
  };
  for (var i=select1.value; i<select1.length; i++) {
    select2.options[i].disabled = false;
  };

  for (var i=select2.value; i<select2.length; i++) {
    select1.options[i].disabled = true;
  };
  for (var i=0; i<=select2.value; i++) {
    select1.options[i].disabled = false;
  };
}