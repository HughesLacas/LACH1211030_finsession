package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	public class PorteDeux extends MovieClip {
		private var ouvre:Sound;
		public function PorteDeux() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void {
			ouvre=new sonPorte; // ajoute le son de la porte
			Main(parent.parent.parent).addEventListener("reset", reset);
		}
		// si la porte s'ouvre
		public function ouvrire():void{
			if(currentFrame==1){
				gotoAndPlay(3);// fait jouer l'animation
				ouvre.play();// fait jouer le son
			}
		}// réinitialise la porte
		private function reset(e:Event):void{
			gotoAndStop(1);
		}
	}
	
}
