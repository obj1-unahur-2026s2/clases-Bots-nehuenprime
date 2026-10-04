
object policia {

  const denuncias = []

  method recibirDenuncia(usuario, tweet) {
    denuncias.add([usuario, tweet])
  }

  method denuncias() = denuncias
}


class Bot {

    method responder(tweet, usuario) {
        return ""
    }
}


object benito inherits Bot {

  const listaNegra = ["robo", "estafa", "armas"]
  method quiereResponder(tweet) =
    tweet.any({ palabra => listaNegra.contains(palabra) })
  override method responder(tweet, usuario) {
    if (self.quiereResponder(tweet)) {
      policia.recibirDenuncia(usuario, tweet)
    }
    return ""
  }
}


class BotPublicidad inherits Bot {

  const palabraPuntual
  const mensaje
  const link

  method quiereResponder(tweet) =
    tweet.any({ palabra => palabra == palabraPuntual })
  override method responder(tweet, usuario) {
    if (self.quiereResponder(tweet)) {
      return mensaje + " " + link + " @" + usuario
    }
    return ""
  }
}


class BotRecolector inherits Bot {

    const usuariosQueTwittearon = []

  override method responder(tweet, usuario) {
    usuariosQueTwittearon.add(usuario)
    return ""
  }

    method usuariosQueTwittearon() = usuariosQueTwittearon
}


object pdtwitter {

  const bots = []
  const tweets = []

  method bots() = bots
  method tweets() = tweets
  method agregarBot(bot) {
    bots.add(bot)
  }
  method twittear(usuario, tweet) {
    if (tweet.size() <= 15) {
      tweets.add(tweet)
      bots.forEach({ bot =>
        const respuesta = bot.responder(tweet, usuario)
        if (respuesta != "") {
          tweets.add(respuesta)
        }
      })
    }
  }
  method home(usuario) =
    tweets.filter({
      tweet => tweet.contains("@" + usuario)
    })
  method tweetsALaNada() =
    tweets.filter({
      tweet => not tweet.any({
        palabra => palabra.contains("@")
      })
    })
}

