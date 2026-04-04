using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S3KObjectDefinitions.SBZ
{
	class RunningDisc : ObjectDefinition
	{
		private ReadOnlyCollection<byte> subtypes;
		private Sprite[] sprite;

		public override string Name
		{
			get { return "Running Disc Control"; }
		}

		public override bool Debug
		{
			get { return true; }
		}

		public override Sprite Image
		{
			get { return sprite[0]; }
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return subtypes; }
		}

		public override string SubtypeName(byte subtype)
		{
			return (subtype & 0xF) == 0 ? "Normal (144)" : "Small (112)";
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return sprite[0];
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			return sprite[(obj.XFlip ? 1 : 0) | (obj.YFlip ? 2 : 0)];
		}

		private int GetRadius(byte subtype)
		{
			return (subtype & 0xF) == 0 ? 72 : 56;
		}

		public override Sprite GetDebugOverlay(ObjectEntry obj)
		{
			int r = GetRadius(obj.SubType);
			int size = r * 2;
			var bitmap = new BitmapBits(size, size);
			bitmap.DrawRectangle(LevelData.ColorWhite, 0, 0, size - 1, size - 1);
			return new Sprite(bitmap, -r, -r);
		}

		public override Rectangle GetBounds(ObjectEntry obj)
		{
			int r = GetRadius(obj.SubType);
			return new Rectangle(obj.X - r, obj.Y - r, r * 2, r * 2);
		}

		public override void Init(ObjectData data)
		{
			subtypes = new ReadOnlyCollection<byte>(new byte[] { 0, 1 });
			sprite = BuildFlippedSprites(ObjectHelper.UnknownObject);
		}

		private Sprite[] BuildFlippedSprites(Sprite sprite)
		{
			var flipX = new Sprite(sprite, true, false);
			var flipY = new Sprite(sprite, false, true);
			var flipXY = new Sprite(sprite, true, true);

			return new[] { sprite, flipX, flipY, flipXY };
		}
	}
}
