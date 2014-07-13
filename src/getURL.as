package {
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	public function getURL(pURL:String , pWindow:String = "_self"):void {
		try { navigateToURL(new URLRequest(pURL), pWindow); }		
		catch (err:Error) { }		
	}
}