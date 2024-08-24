$(document).ready(function() {
    window.addEventListener('message', function(event) {
        var data = event.data;
		if (data.showScreen == true) {
			$(".container").show();
			$("#adminas").text(data.adminName);
		}

		if (data.showScreen == false) {
			$(".container").hide();
		}


    })
})


