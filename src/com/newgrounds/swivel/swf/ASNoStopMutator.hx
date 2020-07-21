/*
 * Swivel
 * Copyright (C) 2012-2017, Newgrounds.com, Inc.
 * https://github.com/Herschel/Swivel
 *
 * Swivel is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Swivel is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Swivel.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.newgrounds.swivel.swf;
import format.abc.Context;
import format.abc.Data;
import format.swf.Data;
import format.as1.Data;
import haxe.Int32;

using com.newgrounds.swivel.swf.AbcUtils;

class ASNoStopMutator implements ISWFMutator
{
	
	public function new() {		
	}

	private function removeAS1StopTags(bytes : haxe.io.Bytes) {
		var atags = SwivelSwf.parseAvm1Bytes(bytes);
		var jj = 0;
		while(jj < atags.length) {
			switch(atags[jj]) {
				case AStop:
					trace("Removing stop tag");
					atags.splice(jj,1);
					jj--;
				default:
			}
			jj++;
		}
		return TDoActions( SwivelSwf.getAvm1Bytes(atags) );
	}
	
	public function mutate(swf : SwivelSwf) : Void {
		swf.compression = SCUncompressed;

		if(Type.enumEq(swf.avmVersion, AVM1)) {
			var i=0;
			//swf.prepend(TDoActions( SwivelSwf.getAvm1Bytes([AGotoFrame(_startFrame), APlay])));
			var f = 0;
			while(i < swf.tags.length) {
				switch(swf.tags[i]) {
					// Todo: Wow, this should probably be recursive?
					case TClip(id, frames, tags):
						var j=0;
						while(j < tags.length) {
							switch(tags[j]) {
								case TDoActions(bytes):
									// tags[j] = removeAS1StopTags(bytes);
								default:
							}
							j++;
						}
					case TDoActions(bytes):
						swf.tags[i] = removeAS1StopTags(bytes);
					default:
						
				}
				i++;
			}
		} else {
			for(i in 0...swf.tags.length) {
				var tag = swf.tags[i];
				switch(tag) {
					// Unimplemented
					default:
				}
			}
			return;
		}
	}
}