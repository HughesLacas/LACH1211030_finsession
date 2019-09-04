package {	import flash.display.MovieClip;	import flash.events.*;	import flash.ui.Keyboard;	public class Main extends MovieClip {		private var ecranCourant:MovieClip;
				public function Main() {			goto("intro");		}		public function goto(destination:String, ecranCourant:MovieClip=null):void {
			if(ecranCourant!=null) ecranCourant.desactiver();
			
			if(destination=="intro"){
				 intro_mc.activer();
				intro_mc.credit_mc.visible=false;
			}else if(destination=="principal"){
				principal_mc.activer();
			}else if(destination=="fin"){
				fin_mc.activer();
			}		}
		public function recommencer():void{
			dispatchEvent(new Event("reset",true));
		}
		
			}//classe}//package