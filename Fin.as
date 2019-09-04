package {	import flash.display.MovieClip;	import flash.events.*;	public class Fin extends MovieClip {
		private var nomEcran:String="fin";				public function Fin() {
			trace(">>> écran",nomEcran,"créé");		}		private function goPrincipal(e:MouseEvent):void {			MovieClip(parent).goto("principal", this);
			Main(parent).recommencer();		}				private function goIntro(e:MouseEvent):void {			MovieClip(parent).goto("intro",this);		}		
		public function activer():void{
			trace("Écran",nomEcran,"activé");
			btPrincipal.addEventListener(MouseEvent.CLICK,goPrincipal);
			btIntro.addEventListener(MouseEvent.CLICK,goIntro);
			visible=true;
		}
		
		public function desactiver():void{
			trace("Écran",nomEcran,"desactivé");
			
			// IMPORTANT: désactiver les écouteurs quand la page
			// est désactivée...
			btPrincipal.removeEventListener(MouseEvent.CLICK,goPrincipal);
			btIntro.removeEventListener(MouseEvent.CLICK,goIntro);
			
			visible=false;
		}
		}//classe}//package