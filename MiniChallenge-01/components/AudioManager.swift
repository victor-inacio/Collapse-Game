import AVFAudio


// Classe que cuida das emissões de áudio do jogo

// Ele é uma classe Builder, que significa que vários métodos deles retornam a própria instância da classe, o que facilita ao chamar vários métodos do objeto de uma vez só.
class AudioManager {
    
    static var generalVolume: Float = 1
    private var player: AVAudioPlayer!
    public var volume: Float {
        
        get {
            return self._volume
        }
        
        set {
            self._volume = newValue
        }
        
    }
    
    private var _volume: Float = 1
    
    static var players: [AudioManager] = []

    init(fileName: String) {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            
        }
        
        guard let soundFileURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: soundFileURL)
            player.volume = AudioManager.generalVolume
            
            AudioManager.players.append(self)
        } catch {
            
        }
    }
    
    
    // O discardableResult serve para o Swift não der warning quando eu chamar estes métodos e não usar o valor retornado por eles
    @discardableResult
    func setVolume(volume: Float, interval: TimeInterval = 0) -> Self {
        player.setVolume(volume * AudioManager.generalVolume, fadeDuration: interval)
        self.volume = volume
        return self
    }
    
    @discardableResult
    func setLoops(loops: Int) -> Self {
        self.player.numberOfLoops = loops
        
        return self
    }
    
    @discardableResult
    func play() -> Self {
        player.prepareToPlay()
        player.play()
        
        return self
    }
    
    
    static func toggleMute() {
        AudioManager.generalVolume = AudioManager.generalVolume == 1 ? 0 : 1
        
        AudioManager.players.forEach { audio in
            audio.player.setVolume(audio.volume * AudioManager.generalVolume, fadeDuration: 0)
        }
    }
}

