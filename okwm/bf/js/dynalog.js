// need to initialise the dynamic logging system when the page loads
Event.observe(window, 'load', initDynamicLogging, false);

 /*
  *	 initialise the dynamic logger - bind onBlur event listener to each field tagged 'dynalog'
  */
function initDynamicLogging(){
//	alert("initialise dynamic logging...");
	loggedElements = getElementsByClass("dynalog");
	for (i = 0; i < loggedElements.length; i++) {

		obj = loggedElements[i];
		Event.observe(obj, 'blur', this.log.bindAsEventListener(obj), false);
	}
//	alert("dynamic logging initialised.");
}

/*
 * change the src of the remote scripting element - this will trigger server side logging
 */
function log(){
	new Ajax.Request("dynamicLogging.html?field=" + this.name + "&value=" + this.value, {asynchronous:true});
}


/* grab Elements from the DOM by className */
function getElementsByClass(searchClass,node,tag) {
	var classElements = new Array();
	if ( node == null )
		node = document;
	if ( tag == null )
		tag = '*';
	var els = node.getElementsByTagName(tag);
	var elsLen = els.length;
	var pattern = new RegExp("(^|\\s)"+searchClass+"(\\s|$)");
	for (i = 0, j = 0; i < elsLen; i++) {
		if ( pattern.test(els[i].className) ) {
			classElements[j] = els[i];
			j++;
		}
	}
	return classElements;
}