$('#backup_type').change(function (){
   if(this.value == 'b2'){
       $('#backup_bucket').show();
       $('#backup_sftp').hide();
   }else{
       $('#backup_bucket').hide();
       $('#backup_sftp').show();
   }
});
$('#api').change(function (){
       if(this.value == 'yes'){
           $('#security_ip').show();
       }else{
           $('#security_ip').hide();
       }
    });