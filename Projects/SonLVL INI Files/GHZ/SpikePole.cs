using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S3KObjectDefinitions.GHZ
{
	class SpikePole : ObjectDefinition
	{
		private List<Sprite> imgs = new List<Sprite>();

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.OpenArtFile("../../Objects/Environ/Spike Pole/KosinskiPM Art/Spike Pole.kospm", CompressionType.KosinskiPlusM);
			for (int i = 0; i < 8; i++)
			{
				imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../../Objects/Environ/Spike Pole/Object Data/Map - Spike Pole.asm", i, 2));
			}
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new List<byte>()); }
		}

		public override string Name
		{
			get { return "Helix of spikes on a pole"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override string SubtypeName(byte subtype)
		{
			return string.Empty;
		}

		public override Sprite Image
		{
			get { return GetFixedSprite(); }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return GetFixedSprite();
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			return GetFixedSprite();
		}

		private Sprite GetFixedSprite()
		{
			if (imgs.Count < 8) return new Sprite();
			List<Sprite> sprs = new List<Sprite>();
			int spikeoffset = 64; 
			for (int i = 0; i < 8; i++)
			{
				Sprite tmp = new Sprite(imgs[i]);
				tmp.Offset(-spikeoffset, 0);
				sprs.Add(tmp);
				spikeoffset -= 16;
			}
			return new Sprite(sprs.ToArray());
		}

		public override PropertySpec[] CustomProperties
		{
			get { return new PropertySpec[0]; }
		}
	}
}
