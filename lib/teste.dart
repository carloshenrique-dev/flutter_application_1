import 'dart:isolate';
import 'dart:async';

class IsolateRomaneioUpdate {
  Isolate? isolate;
  IsolateRomaneioUpdate() {
    _start();
  }
  void _start() async {
    ReceivePort receivePort = ReceivePort();
    isolate = await Isolate.spawn(runTimer, receivePort.sendPort);
    receivePort.listen((data) async {
      /*bool conexao = await SemConexaoController().checkConnectivity();
      if (conexao) {
        if (!romaneio.isRomaneioInicioSynchronized()) {
          await romaneio.setInicioRomaneio();
        } else if (romaneio.hasUnsyncrhonizedParadas()) {
          await romaneio.envParadas();
        } else if (romaneio.hasUnsyncrhonizedDeliveries()) {
          await romaneio.envEntregas();
        }
      }*/
    });
  }

  static void runTimer(SendPort sendPort) async {
    int count = 0;
    Timer.periodic(const Duration(seconds: 30), (t) {
      sendPort.send(count);
      count++;
    });
  }

  bool killIsolate() {
    if (isolate != null) {
      //print("Stopping isolate");
      isolate!.kill();
      isolate = null;
      return true;
    } else if (isolate == null) {
      return false;
    } else {
      return false;
    }
  }
}
