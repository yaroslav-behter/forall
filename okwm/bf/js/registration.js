Event.observe(window, 'load', initRegistration, false);
Event.observe(window, 'unload', Event.unloadCache, false);

document.onkeypress = evaluateReturnKeyPress;

// variable for storing the ajax response
var addressResponse;
var sessionID;
var startRegURL;
var initDone = false;
var geoLocatedCountry;

var contentUrlAboutUsTC;
var contentUrlPrivatePolicy;

//Variable containing references to child windows - see getWindow()
var oWindowArray = null;

/*
 * Disable auto-complete on all fields.
 */
function disableAutoComplete() {
	document.forms[0].setAttribute("autocomplete", "off");
}
/*
 * initialise everything
 */
function initRegistration(){

	if (initDone) {
		return;
	}

	//Disable fields (controlled via querystring)
	DisableFields();

	//Turn off the AutoComplete on the ZipCode field.
	document.getElementById('zipCode').setAttribute("autocomplete", "off");

	//Calling the URL/Image
	URLTrackingTag( startRegURL );

	//Hides all the relevant parts of the Address block
	addressBlockInit();

	// Checks the locale of the browser
	lookupFunctionality();

	// Bind 'click' event to Lookup button
    avsButton = $("avsLookupButton");
	Event.observe(avsButton, 'click', this.avsLookup.bindAsEventListener(avsButton), false);

	// Bind 'change' event to selector
	addressSelector = $("selectAddressButton");
	Event.observe(addressSelector, 'click', this.addressSelected.bindAsEventListener(addressSelector), false);

	// Bind 'blur' event to password fields
	passwordSelector = $("password");
	Event.observe(passwordSelector, 'blur', this.passwordValidator.bindAsEventListener(passwordSelector), false);
	Event.observe(passwordSelector, 'keyup', this.passwordValidator.bindAsEventListener(passwordSelector), false);


	confirmPasswordSelector = $("confirmPassword");
	Event.observe(confirmPasswordSelector, 'blur', this.passwordValidator.bindAsEventListener(confirmPasswordSelector), false);
	Event.observe(confirmPasswordSelector, 'keyup', this.passwordValidator.bindAsEventListener(confirmPasswordSelector), false);


	// Bind 'change' event to country selector
	countrySelectorList = $("countryOfResidenceList");
	Event.observe(countrySelectorList, 'change', function() {

		//Check the address fields to display
		addressFieldCheck();

		//Updates the hidden field to same as the countries list
		$("countryOfResidence").value = $F("countryOfResidenceList");

		lookupFunctionality();

	}, false);


	// Bind 'click' event to the promo code
	promoCodeSelectorYes = $("promoCodeYes");
	Event.observe(promoCodeSelectorYes, 'click', function() {

		if ( $("promoCodeYes").checked ) {
			Element.show('promoCodeSelectionEntry');
		}
	}, false);

	// Bind 'click' event to the promo code
	promoCodeSelectorNo = $("promoCodeNo");
	Event.observe(promoCodeSelectorNo, 'click', function() {

		if ( $("promoCodeNo").checked ) {
			Element.hide('promoCodeSelectionEntry');
			//Reset the PromoReferEarnCode field
			Field.clear('promoReferEarnCode');
		}
	}, false);


	// Bind 'change' event to security question
	firstNameField = $("firstName");
	Event.observe(firstNameField, 'blur', updateFirstName, false);

	// Bind 'change' event to security question
	surnameField = $("surname");
	Event.observe(surnameField, 'blur', updateSurname, false);

	//Don't do it again
	initDone = true;

}

function evaluateReturnKeyPress(evt) {
	var evt  = (evt) ? evt : ((event) ? event : null);
	var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
	if (evt.keyCode == 13 && node.nodeName == "INPUT") {
		if (node.id == "Registration.ButtonName.LookUp") {
			//Check that the country is GB
			if ( $F('countryOfResidenceList') == 'GB' && Element.visible($('avsLookupButton')) ) {
				avsLookup();
			} else {
				return false;
			}
		} else if (node.id == "submitButton") {
			validateAndSubmit();
		} else {
			return false;
		}
	} else {
		return true;
	}
}

/*
 * this method clears the address fields
 */
function addressBlockInit() {

// ------ CHECKING THE GEO LOCATED IP INIT -----
	if ( geoLocatedCountry != null && geoLocatedCountry == "DE" ) {
		Element.show("GermanTandC");
	} else {
		Element.show("NormalTandC");
	}
// -----------------------------------------


// ------ CHECKING UNDE AGE ERROR INIT -----
	if ( $('under18.errors') != null && $('under18.errors').innerHTML != "" ) {
		$('dateOfBirth.day').className = 'errorField';
		$('dateOfBirth.month').className = 'errorField';
		$('dateOfBirth.year').className = 'errorField';
	}
// -----------------------------------------

// ------ SPECIFY THE ADDRESS FIELD LENGTH INIT -----

	//This only works in FireFox, need to implement an IE method.
	document.getElementById('address1').setAttribute('maxlength', 50);
	document.getElementById('town').setAttribute('maxlength', 50);
	document.getElementById('county').setAttribute('maxlength', 50);
	document.getElementById('zipCode').setAttribute('maxlength', 8);

// --------------------------------------------------


// ------ MANUAL ADDRESS CHANGE INIT-----
	$('addressManualEntry').value = true;
// --------------------------------------

// ------ PASSWORD ERROR AND CONFIRM PASSWORD INIT-----
	if ( $('password') != null && $('confirmPassword') != null && $('password').className == 'errorField' ) {
		$('confirmPassword').className = 'errorField';
	}
// --------------------------------------

//----------PROMO CODE INIT --------------
	//Check if the PromoCode field is empty, if not then display it.
	if ( $('promoReferEarnCode').value.trim().length > 0 ) {
		$('promoCodeYes').checked = true;
		Element.show('promoCodeSelectionEntry');
	} else {
		$('promoCodeNo').checked = true;
		Element.hide('promoCodeSelectionEntry');
	}
// ----------------------------------------

//------ COUNTRY SELECTION INIT --------

	if ( $('countryOfResidence').value.trim().length > 0 ) {

		var existingSelection = $('countryOfResidence').value;

		for ( i = 0; i < $("countryOfResidenceList").options.length; i++) {

			if ( $("countryOfResidenceList").options[i].value == existingSelection ) {
				$("countryOfResidenceList").options[i].selected = true;
				foundQuestion = true;
			}
		}
	}

//---------------------------------------


	// hide spinner effect
	Element.hide('spinner');

	// hide the address selection field
	Element.hide('addressSelectorRow');

	// hide the house number field
	Element.hide('zipCodeMessage');

	// hide the address rows
	Element.hide('addressRows');
}

/*
 * This method is called on the address field lookup
 */
function usernameFieldCheck(){

 // ajax lookup for the postcode
 new Ajax.Request('usernameFieldLookup.html', {
 parameters:'username=' + $F('username'),
 method:'post',
 onSuccess:successUsernameField,
 onFailure:function(request) {},
 onLoading:function(request) {},
 onComplete:function(request) {}
 });
}

/**
 * handle ajax response for address field
 */
var successUsernameField = function(t) {

	// store the response text
	usernameFieldListResponse = t.responseText;

	var usernameListArray = usernameFieldListResponse.split(",");

		if ( usernameListArray[0].length == "true") {
		//	Element.show('usernameFullLine1');
		// Show success message (bold & green)
		} else {
		//	Element.hide('usernameFullLine1');
		// Show fail message (red)
		// Display alternatives
		}

}


/*
 * This method is called on the address field lookup
 */
function addressFieldCheck(){

	// ajax lookup for the postcode
    new Ajax.Request('addressFieldLookup.html', {
    	parameters:'localeCode=' + $F('countryOfResidenceList'),
    	method:'post',
    	onSuccess:successAddressField,
    	onFailure:function(request) {},
    	onLoading:function(request) {},
    	onComplete:function(request) {}
    });
}

/**
 * handle ajax response for address field
 */
var successAddressField = function(t) {

	// store the response text
	addressFieldListResponse = t.responseText;

	var addressListArray = addressFieldListResponse.split(",");

		if ( addressListArray[0].length > 0 ) {
			Element.show('addressFullLine1');
		} else {
			Element.hide('addressFullLine1');
		}

		if ( addressListArray[1].length > 0 ) {
			Element.show('addressFullLine2');
		} else {
			Element.hide('addressFullLine2');
		}

		if ( addressListArray[2].length > 0 ) {
			Element.show('townFullLine');
		} else {
			Element.hide('townFullLine');
		}

		if ( addressListArray[3].length > 0 ) {
			Element.show('countyFullLine');
		} else {
			Element.hide('countyFullLine');
		}

		if ( addressListArray[4].length > 0 ) {
			Element.show('zipCodeRows');
		} else {
			Element.hide('zipCodeRows');
		}

		if ( addressListArray.length > 5 && addressListArray[5].length > 0 ) {
			updateCurrencyList( addressListArray[5] );
		}

}

/**
 * toggle showing of ajax postcode lookup - should be visible only if we are in UK
 */
function lookupFunctionality() {

	Element.hide('zipCodeMissingMessage');

	if ( !initDone && $('postcode_mainError') == null ) {

		//Reset and hide the Post Code errors, as it's not required for any other country
		$('zipCode').className = 'inputFields';
		if ( $('postcode_mainError') != null ) Element.hide('postcode_mainError');
	}

	//Set the address entry as false as only GB has postcode lookup
	$('addressManualEntry').value = true;

	//Display the address fields
	prepForOtherLocale( false );

	Element.show('county_textfield');

	if ( $('missingStateError') != null ) Element.hide('missingStateError');


}


/*
 * This method is called when the page has fully loaded
 */
function URLTrackingTag( passedURL ){

	var sessionID = readCookie("JSESSIONID");
	if ( sessionID != null ) {
		$('imageTrackingTag').src=passedURL + sessionID;
	}
}


/*
 * This method is called on the address lookup
 */
function avsLookup(){

	if (!validateZipCode()) { // both validation will take place
		return;
	}

    new Ajax.Request('addressLookup.html', {
    	parameters:'postcode=' + $F("zipCode") ,
    	method:'post',
    	onSuccess:success,
    	onFailure:function(request) {
		    Element.hide('spinner');
		    Element.show('addressRows');
		},
    	onLoading:function(request) { setTimeout('spinnerTimeOut()',2000); Element.show('spinner'); },
    	onComplete:function(request) { Element.hide('spinner'); }
    });

	checkAddressLabels();
}


function spinnerTimeOut() {

	//Checks if the spinner is still showing and then hides it.
	if ( Element.visible( $('spinner') ) ) {
		Element.hide('spinner');
	}
}


/**
 * handle ajax response
 */
var success = function(t) {



Element.hide('zipCodeNoMatchingAddressMessage');

	// store the response text
	addressResponse = t.responseText;

	var addressArray=addressResponse.split("~");

	// remove last element of array - if not you get an empty address
	addressArray.pop();

	//Clear the Address selection list
	$('addressSelector').options.length = 0

	if (addressArray.length == 0) {

		Element.show('zipCodeNoMatchingAddressMessage');
		$('zipCode').className = 'errorField';

	} else if (addressArray.length == 1) {

		//PostCode lookup found the entry and set the value to false
		//Until they click on the edit button
		$('addressManualEntry').value = false;

		//Clear all errors as an address has been returned.
		clearErrors('true');

		//Hide the bits you don't need
		hideLookUpPanel();

		Element.hide('addressRows');

		selected = 0;

		addressValues=addressArray[selected].split("|");
		$('address1').value = addressValues[1];
		$('address1').text = addressValues[1];
		$('town').value = addressValues[3];
		$('town').text = addressValues[3];
		$('county').value = addressValues[4];
		$('county').text = addressValues[4];
		$('zipCode').value = addressValues[5];
		$('zipCode').text = addressValues[5];


		// set the values for the uneditable address fields
		Element.update('address1_label', addressValues[1])
		Element.update('town_label', addressValues[3])
		Element.update('county_label', addressValues[4])
		Element.update('postcode_label', addressValues[5])


		// toggle showing the editable input fields
		if ( addressValues[4].trim().length > 0 ) {
			Element.show('county_label_tag');
		} else {
			Element.hide('county_label_tag');
		}

		//Shows the prefilled results.
		Element.hide('addressSelectorRow');
		Element.show('addressRowsLabels');

	} else if (addressArray.length > 1) {

		//PostCode lookup found the entry and set the value to false
		//Until they click on the edit button
		$('addressManualEntry').value = false;

		//Reset the
		$('zipCode').className = 'inputFields';

		hideLookUpPanel();

		var count = 0;

		// loop thru the addresses creating the html for the selection box

		addressArray.each( function(address){
			address = address.trim();
			var addressVal = address.split("|");

			var optionText = "";

			if ( addressVal[1].length > 0 ) {
				optionText = addressVal[1];
			}
			if ( addressVal[2].length > 0 ) {
				optionText = optionText + ", " + addressVal[2];
			}
			if ( addressVal[3].length > 0 ) {
				optionText = optionText + ", " + addressVal[3];
			}
			if ( addressVal[4].length > 0 ) {
				optionText = optionText + ", " + addressVal[4];
			}


			// add options to the select box
        	$("addressSelector").options[count] = new Option(optionText);
            count++;

		});

		// resize the select so it shows multiple addresses (max 7)
		selectorSize = 7;
		if (addressArray.length < 7){
			selectorSize = addressArray.length;
		}


		Element.show('addressSelectorRow');

		// deselect all the options
		$("addressSelector").selectedIndex = -1;
		// resize the selection so it shows as a list
		$("addressSelector").size = selectorSize;
	}
}

function hideLookUpPanel() {

	Element.hide('zipCodeNoMatchingAddressMessage');
	Element.hide('zipCodeInvalidMessage');
	Element.hide('zipCodeMissingMessage');

	Element.hide('zipCodeMessage');
	Element.hide('zipCodeRows');
	Element.hide('avsLookupButton');
}



/**
 */
function addressSelected() {

	if ( $("addressSelector").selectedIndex == -1) {
		return false;
	}

	// hide the address selection field
	Element.hide('addressSelectorRow');

	// parse the response (should  be something like: "0|7 Mock Street|Mock Town|Mock County|abcdef~" )
	selected = $("addressSelector").selectedIndex;
	var addressArray=addressResponse.split("~");
	addressValues=addressArray[selected].split("|");
	$('address1').value = addressValues[1];
	$('town').value = addressValues[3];
	$('county').value = addressValues[4];
	$('zipCode').value = addressValues[5];

	// set the values for the uneditable address fields
	Element.update('address1_label', addressValues[1]);
	Element.update('town_label', addressValues[3]);
	Element.update('county_label', addressValues[4]);
	Element.update('postcode_label', addressValues[5]);

	// toggle showing the editable input fields
	Element.hide('addressRows');
	Element.hide('zipCodeMessage');
	Element.hide('zipCodeRows');
	Element.hide('avsLookupButton');
	Element.show('addressRowsLabels');


	// toggle showing the editable input fields
	if ( addressValues[4].trim().length > 0 ) {
		Element.show('county_label_tag');
	} else {
		Element.hide('county_label_tag');
	}
}

function passwordValidator() {
	var eventDetails = arguments[0];
	if(!eventDetails.target) eventDetails.target = eventDetails.srcElement

	var errorMatrix = new Array(true, true, true, true);
	var enteredValue = $('password').value;
	if(enteredValue.length == 0) {
		errorMatrix[0] = false;
	} else if (enteredValue.length < 8) {
		errorMatrix[1] = false;
	} else if (enteredValue.length > 20) {
		errorMatrix[2] = false;
	}
	if (!((enteredValue.search(/[a-z]+/) > -1 || enteredValue.search(/[A-Z]+/) > -1) && (enteredValue.search(/[0-9]+/) > -1))) {
		errorMatrix[3] = false;
	}
	if(!errorMatrix[0]) {
		$('passwordError').removeClassName("tooShort");
		$('passwordError').removeClassName("tooLong");
		$('passwordError').removeClassName("validCharacters");
		$('passwordError').removeClassName("validPassword");
	} else {
		(errorMatrix[1])?$('passwordError').removeClassName("tooShort"):$('passwordError').addClassName("tooShort");
		errorMatrix[2]?$('passwordError').removeClassName("tooLong"):$('passwordError').addClassName("tooLong");
		errorMatrix[3]?$('passwordError').removeClassName("validCharacters"):$('passwordError').addClassName("validCharacters");
		(errorMatrix[0] && errorMatrix[1] && errorMatrix[2] && errorMatrix[3])?$('passwordError').addClassName("validPassword"):$('passwordError').removeClassName("validPassword");
		if(eventDetails.type == "blur" && eventDetails.target.id == "password") (errorMatrix[0] && errorMatrix[1] && errorMatrix[2] && errorMatrix[3])?$('passwordError').removeClassName("alertMessage"):$('passwordError').addClassName("alertMessage");
	}
	if((eventDetails.type == "blur" && eventDetails.target.id == "confirmPassword") || eventDetails.target.id != "confirmPassword") {
		if($('confirmPassword').value.length > 0 && $('password').value.length > 0) {
			($('password').value === $('confirmPassword').value)?$('passwordMatch').removeClassName("noMatch"):$('passwordMatch').addClassName("noMatch");
			($('password').value != $('confirmPassword').value)?$('passwordMatch').addClassName("alertMessage"):$('passwordMatch').removeClassName("alertMessage");

		} else {
			$('passwordMatch').removeClassName("noMatch")
		}
	} else if(($('confirmPassword').value == $('password').value)||!($('confirmPassword').value.length > 0 && $('password').value.length > 0)) {
		$('passwordMatch').removeClassName("noMatch")
	}
}

function countySelector() {

	var selectedObjectValue = null;
}


function prepForGBLocale( clearFields ) {

	if ( clearFields ) {
		Field.clear('address1');
		Field.clear('town');
		Field.clear('county');
		Field.clear('zipCode');
	}

	Element.show('zipCodeMessage');
	Element.show('zipCodeRows');
	Element.show('avsLookupButton');

	Element.hide('addressRows');

	Element.hide('addressRowsLabels');
	Element.hide('addressSelectorRow');
	Element.hide('zipCodeNoMatchingAddressMessage');
	Element.hide('zipCodeInvalidMessage');

	checkAddressLabels();
}

function prepForOtherLocale( clearFields ) {

	if ( clearFields ) {
		Field.clear('address1');
		Field.clear('town');
		Field.clear('county');
		Field.clear('zipCode');
	}

	Element.show('addressRows');
	Element.show('zipCodeRows');
	Element.hide('addressRowsLabels');
	Element.hide('addressRowsLabels');
	Element.hide('zipCodeMessage');
	Element.hide('avsLookupButton');
	Element.hide('addressSelectorRow');
	Element.hide('zipCodeNoMatchingAddressMessage');
	Element.hide('zipCodeInvalidMessage');


	//Checks if the field title labels should be displayed
	checkAddressLabels();
}


/*
 * check to see if the address field exists, if so, then display the field, else hide
 */
function checkAddressLabels() {

	if ( $('address1CheckText').innerHTML == "" ) {
		Element.hide('addressFullLine1');
	} else {
		Element.show('addressFullLine1');
	}

	if ( $('townCheckText').innerHTML == "" ) {
		Element.hide('townFullLine');
	} else {
		Element.show('townFullLine');
	}

	if ( $('postcodeCheckText').innerHTML == "" ) {
		Element.hide('zipCodeRows');
	} else {
		Element.show('zipCodeRows');
	}
}


/*
 * check to see if the currency exists, if so, update the currency selection list
 */
function updateCurrencyList( passedCurrency ) {

	for ( i = 0; i < $("currency").options.length; i++) {
		if ( $("currency").options[i].value == passedCurrency ) {
			$("currency").options[i].selected = true;
		}
	}
}


/*
 * prototyped trim extension to String object
 */
String.prototype.trim = function() {
    return(this.replace(/^\s+/,'').replace(/\s+$/,''));
}

/*
 * toogles the show/hide of an object
 */
function toggle(obj) {
	var el = document.getElementById(obj);
	if ( el.style.display != 'none' ) {
		el.style.display = 'none';
	}
	else {
		el.style.display = '';
	}
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) {
		  return c.substring(nameEQ.length,c.length);
		  }
	}
	return null;
}

/*
 * Opens a window based on the parameters specified
 *
 */
function getWindow(iWindowArrayIndex, sURL, bAutoScroll, iHeight, iWidth, bNormalWindow){
	//Initialise array if not already done
	if(oWindowArray == null) {
		oWindowArray = new Array();
	}

	try {
		oWindowArray[iWindowArrayIndex].status = "";
		oWindowArray[iWindowArrayIndex].document.location = sURL;
		oWindowArray[iWindowArrayIndex].focus();
	}catch(x){
		//Windows doesn't exist so create it
		try{
			oWindowArray[iWindowArrayIndex] = window.open(sURL, "betfairSpawn"+iWindowArrayIndex,'height='+ iHeight +',width='+ iWidth +',top=' + ((screen.availHeight - iHeight) / 2) + ",screenY=" + ((screen.availHeight - iHeight) / 2) + ",left=" + ((screen.availWidth - iWidth) / 2) + ",screenX=" + ((screen.availWidth - iWidth) / 2) +",scrollbars="+((bAutoScroll)? "no":"yes")+",resizable=yes,menubar=no,toolbar=no,titlebar=yes')");
			oWindowArray[iWindowArrayIndex].status = "";
		}catch(x){
			alert(loginMsg_SpawnBlocker);
			return null;
		}
	}
}

function validateAndSubmit() {
	// remove all non numeric characters from the telephone field (see SCR 32086)
	var TelephoneNumber = document.getElementById("contactNumber.number")
	if (TelephoneNumber != null) {
		TelephoneNumber.value = TelephoneNumber.value.replace(/\D/g,'');
	}

	var lookUp = $('avsLookupButton');

	//Clear all the error fields.
	clearErrors();

	// address incomplete
	if(Element.visible(lookUp)) {

		if ( validateZipCode() ) {
			document.forms['registrationForm'].submit();
		}
		return;

		Element.hide('missingStateError');

		if ( $('postcode_mainError') != null && Element.visible('postcode_mainError') ) {
			Element.hide('postcode_mainError');
			Element.show('zipCodeMissingMessage');
		}

	}

	//Enable fields again (necessary so that values are passed over)
	EnableFields();

	//Disable the button for 5 seconds so that the user doesn't double click by accident
	$('submitButton').disabled = 'true';
	setTimeout('submitButtonTimeOut()',5000);
	document.forms['registrationForm'].submit();
}

function submitButtonTimeOut() {
	//Re-enable the button in the case the form doesn't get submitter properly or some other error.
	$('submitButton').disabled = '';
}


function validateZipCode() {

	Element.hide('zipCodeNoMatchingAddressMessage');
	Element.hide('zipCodeInvalidMessage');
	Element.hide('zipCodeMissingMessage');
	$('zipCode').className = 'inputFields';
	var zipCode = $F("zipCode");
	zipCode = zipCode.toUpperCase();

	// valid
	if(zipCode.match(/^[A-Z][A-Z]?[0-9][A-Z0-9]? ?[0-9][ABDEFGHJLNPQRSTUWXYZ]{2}$/)) {
		return true;
	}

	//invalid
	if(zipCode == ""){ // was missing

		//Clear the server validation
		if ( $('postcode_mainError') != null ) Element.hide('postcode_mainError');

		//Display the Post Code missing error instead
		Element.show('zipCodeMissingMessage');
	} else { // didn't match
		Element.show('zipCodeInvalidMessage');
	}

	$('zipCode').className = 'errorField';

	return false;

}

/*
 * Turns the first char of the first name into a capital
 *
 */
function updateFirstName() {
	var firstNameField = $("firstName").value;
	var firstChar = firstNameField.charAt(0).toUpperCase();
	var restOfName = firstNameField.substring( 1, firstNameField.length );
	var newFirstName = firstChar + restOfName;

	$("firstName").value = newFirstName;
}


/*
 * Turns the first char of the surname into a capital
 *
 */
function updateSurname() {
	var surnameField = $("surname").value;
	var firstChar = surnameField.charAt(0).toUpperCase();
	var restOfName = surnameField.substring( 1, surnameField.length );
	var newSurname = firstChar + restOfName;

	$("surname").value = newSurname;
}

function limitText(limitField, limitNum) {
	if (limitField.value.length > limitNum) {
		limitField.value = limitField.value.substring(0, limitNum);
	} else {
		limitCount.value = limitNum - limitField.value.length;
	}
}


function clearErrors( clearFields ) {

	//Clear all the errors
	if ( $('zipCodeNoMatchingAddressMessage') != null ) {
		Element.hide('zipCodeNoMatchingAddressMessage');
	}

	if ( $('zipCodeMissingMessage') != null ) {
		Element.hide('zipCodeMissingMessage');
	}

	if ( $('zipCodeInvalidMessage') != null ) {
		Element.hide('zipCodeInvalidMessage');
	}


	if ( clearFields ) {

		if ( $('address1_mainError') != null ) {
			Element.hide('address1_mainError');
		}

		if ( $('town_mainError') != null ) {
			Element.hide('town_mainError');
		}

		if ( $('county_mainError') != null ) {
			Element.hide('county_mainError');
		}

		if ( $('postcode_mainError') != null ) {
			Element.hide('postcode_mainError');
		}

		//Reset fields.
		$('address1').className = 'inputFields';
		$('county').className = 'inputFields';
		$('town').className = 'inputFields';
		$('zipCode').className = 'inputFields';
		$('town').className = 'inputFields';
	}
}




/*
 * Hides the passed object and adds to the error list if something is not available.
 *
 */
function hideSections( passedObjectName ) {

	var workingObject = $( passedObjectName );
	var errorField = $( 'hidden_errors' ).innerHTML;

	if ( workingObject != null ) {
		Element.hide( passedObjectName );
	} else {
		errorField = errorField + " | Problem HIDING the <b>" + passedObjectName + "</b> object!!";
		$( 'hidden_errors' ).innerHTML = errorField;
	}
}

/*
 * Shows the passed object and adds to the error list if something is not available.
 *
 */
function showSections( passedObjectName ) {

	var workingObject = $( passedObjectName );
	var errorField = $( 'hidden_errors' ).innerHTML;

	if ( workingObject != null ) {
		Element.show( passedObjectName );
	} else {
		errorField = errorField + " | Problem SHOWING the <b>" + passedObjectName + "</b> object!!";
		$( 'hidden_errors' ).innerHTML = errorField;
	}
}

/*
 * Changes CSS class on the passed object and adds to the error list if something is not available.
 *
 */
function changeClasses( passedObjectName, passedNameOfClass ) {

	var workingObject = $( passedObjectName );
	var errorField = $( 'hidden_errors' ).innerHTML;

	if ( workingObject != null && passedObjectName != "zipcode") {
		$(passedObjectName).className = passedNameOfClass;
	} else {
		errorField = errorField + " | Problem getting <b>" + passedObjectName + "</b> object to set CSS class (" + passedNameOfClass + ")!!";
		$( 'hidden_errors' ).innerHTML = errorField;
	}
}


function disableCtrlKeyCombination(e) {

	//list all CTRL + key combinations you want t02/10/2006o disable
	var forbiddenKeys = new Array("v"); //But you can add so many more to the list
	var key;
	var isCtrl;

	if (window.event){

		key = window.event.keyCode;     //IE

		if (window.event.ctrlKey) {
			isCtrl = true;
		} else {
			isCtrl = false;
		}
	} else {
		key = e.which;     //Firefox

		if (e.ctrlKey) {
			isCtrl = true;
		} else {
			isCtrl = false;
		}
	}

	//if Ctrl is pressed check if other key is in forbidenKeys array
	if (isCtrl) {
		for(i=0; i<forbiddenKeys.length; i++) {
			//case-insensitive comparation
			if(forbiddenKeys[i].toLowerCase() == String.fromCharCode(key).toLowerCase()) {
				return false;
			}
		}
	}

	return true;
}


function spawn(passedDestination, passedAnchor) {

	if ( passedDestination == 'aboutUsTermsAndConditions') {
		var addressListArray = contentUrlAboutUsTC.split(",");
	    aboutStart =  addressListArray[1].substring(0, addressListArray[1].lastIndexOf('\''));

	    aboutStart = aboutStart+"&jumpTo="+passedAnchor+'\'';

		newAddress = addressListArray[0]+','+aboutStart+','+addressListArray[2]+','+addressListArray[3]+','+addressListArray[4];
		eval( newAddress );
	} else if ( passedDestination == 'privacyPolicy' ) {
		var addressListArray = contentUrlPrivatePolicy.split(",");
		//Remove last ' so that parameter can be added to the end
	    aboutPolicy =  addressListArray[1].substring(0, addressListArray[1].lastIndexOf('\''));

	    //adding new parameter
	    aboutPolicy = aboutPolicy+"&jumpTo="+passedAnchor+'\'';

	    //creating new string
		newAddress = addressListArray[0]+','+aboutPolicy+','+addressListArray[2]+','+addressListArray[3]+','+addressListArray[4];
		eval( newAddress );

		eval( contentUrlPrivatePolicy+ "&jumpTo="+passedAnchor );
	}
}

var ie5 = (document.getElementsByTagName && document.all) ? true : false;

