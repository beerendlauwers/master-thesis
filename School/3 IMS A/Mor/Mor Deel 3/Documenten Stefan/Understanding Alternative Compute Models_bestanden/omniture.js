Hashtable.prototype.hash = null;
Hashtable.prototype.keys = null;
Hashtable.prototype.location = null;

function Hashtable()
{
    this.hash = new Array();
    this.keys = new Array();
    this.location = 0;
}


Hashtable.prototype.get = function (key)
{
    return this.hash[key];
}


Hashtable.prototype.put = function (key, value)
{
     if (value == null)
         return null;

     if (this.hash[key] == null)
         this.keys[this.keys.length] = key;
    
    this.hash[key] = value;
}


function formatString(str) {
    return str.replace(/[^a-zA-Z0-9\s\:\.\(\)\!\@\#\$\%\^\&\*\{\}\[\]\+\-\_\?\;\/\~\"]+/g,'');
}


function checkFieldValue(fieldId)
{
    if (document.getElementById(fieldId) != null)
    {
        return (document.getElementById(fieldId).value != null && document.getElementById(fieldId).value != '');
    }
    else
        return false;
}

var omniturePropTable = new Hashtable();


omniturePropTable.put("blogView", "blog view");
omniturePropTable.put("blogAddReply", "blog reply - add");
omniturePropTable.put("blogCreated", "blog - created");

omniturePropTable.put("threadView", "thread view");
omniturePropTable.put("threadAddComment", "thread comment - add");
omniturePropTable.put("threadCreated", "thread - created");

omniturePropTable.put("documentView", "document view");
omniturePropTable.put("documentAddComment", "document comment - add");
omniturePropTable.put("documentPublished", "document - published");
