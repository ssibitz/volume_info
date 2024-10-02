# volume_info
Its a simple plugin for showing volume storage information in GB like total, free, used

# simple usage example how to get the volume information
      final _volumeInfoPlugin = VolumeInfo();
      double _volumeSpaceTotalInGB = 0.0;
      double _volumeSpaceFreeInGB = 0.0;
      double _volumeSpaceUsedInGB = 0.0;
      
      @override
      void initState() {
        super.initState();
        initPlatformState();
      }
      
      // Platform messages are asynchronous, so we initialize in an async method.
      Future<void> initPlatformState() async {
        double volumeSpaceTotalInGB;
        double volumeSpaceFreeInGB;
        double volumeSpaceUsedInGB;
        // Platform messages may fail, so we use a try/catch PlatformException.
        // We also handle the message potentially returning null.
        try {
          volumeSpaceTotalInGB = await _volumeInfoPlugin.getVolumeSpaceTotalInGB() ?? 0;
        } on PlatformException {
          volumeSpaceTotalInGB = -1;
        }
    
        try {
          volumeSpaceFreeInGB = await _volumeInfoPlugin.getVolumeSpaceFreeInGB() ?? 0;
        } on PlatformException {
          volumeSpaceFreeInGB = -1;
        }
    
        try {
          volumeSpaceUsedInGB = await _volumeInfoPlugin.getVolumeSpaceUsedInGB() ?? 0;
        } on PlatformException {
          volumeSpaceUsedInGB = -1;
        }
  
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;
  
      setState(() {
        _volumeSpaceTotalInGB = volumeSpaceTotalInGB;
        _volumeSpaceFreeInGB = volumeSpaceFreeInGB;
        _volumeSpaceUsedInGB = volumeSpaceUsedInGB;
      });
    }
