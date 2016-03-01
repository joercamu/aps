# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
	$('#modification_attachment_file').change ->
		$("#file_horario").val($(this).val())
	# document.getElementById("modification_attachment_file").addEventListener "change", () ->
	# 	


#  $(document).ready(function()
# {
#   document.getElementById("upload").onchange = function () {
#   document.getElementById("file_horario").value = this.value;
#                 };
# });