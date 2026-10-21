import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/services/share_service.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/share_text_builder.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

enum ShareChannel { whatsapp, copy, system }

class ShareItineraryParams extends Equatable {
  const ShareItineraryParams({
    required this.itinerary,
    required this.from,
    required this.to,
    required this.channel,
  });

  final Itinerary itinerary;
  final Place from;
  final Place to;
  final ShareChannel channel;

  @override
  List<Object> get props => [itinerary, from, to, channel];
}

class ShareItinerary extends UseCase<void, ShareItineraryParams> {
  ShareItinerary(this._service);
  final ShareService _service;

  @override
  Future<Either<Failure, void>> call(ShareItineraryParams p) async {
    try {
      final text = ShareTextBuilder.build(
        itinerary: p.itinerary,
        from: p.from,
        to: p.to,
      );
      switch (p.channel) {
        case ShareChannel.whatsapp:
          // Sans WhatsApp, on retombe sur le partage du téléphone.
          if (!await _service.openWhatsApp(text)) {
            await _service.shareText(text);
          }
        case ShareChannel.copy:
          await _service.copy(text);
        case ShareChannel.system:
          await _service.shareText(text);
      }
      return const Right(null);
    } catch (_) {
      return const Left(LocalFailure('Partage impossible.'));
    }
  }
}
