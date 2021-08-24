import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/select_time/select_time.dart';
import 'package:timezones/time_zones/time_zones.dart';
import 'package:timezones/l10n/l10n.dart';

class TimeZonesPage extends StatelessWidget {
  const TimeZonesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TimeZonesBloc(timeZoneRepository: context.read<TimeZoneRepository>())
            ..add(const TimeZonesFetchRequested()),
      child: const TimeZonesView(),
    );
  }
}

class TimeZonesView extends StatelessWidget {
  const TimeZonesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectTimeListener(
      onTimeChanged: (value) =>
          context.read<TimeZonesBloc>().add(TimeZonesTimeSelected(time: value)),
      onTimeZoneNmaeChanged: (value) => context
          .read<TimeZonesBloc>()
          .add(TimeZonesTimeZoneNameSelected(timeZoneName: value)),
      child: Scaffold(
        body: BlocConsumer<TimeZonesBloc, TimeZonesState>(
          listener: (context, state) {
            if (state.errorAddingStatus == ErrorAddingStatus.duplicated) {
              final l10n = context.l10n;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  key: const Key('timeZonesView_duplicatedTimeZone_snackBar'),
                  content: Text(l10n.duplicateTimeZone),
                ),
              );
            } else if (state.errorAddingStatus == ErrorAddingStatus.notFound) {
              final l10n = context.l10n;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  key: const Key('timeZonesView_notFoundTimeZone_snackBar'),
                  content: Text(l10n.notFoundTimeZone),
                ),
              );
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case TimeZonesStatus.loading:
                return const TimeZonesLoadingView();
              case TimeZonesStatus.error:
                return const TimeZonesErrorView();
              case TimeZonesStatus.populated:
                return state.timeZones.items.isEmpty
                    ? const TimeZonesEmptyView()
                    : TimeZonesPopulatedView(timeZones: state.timeZones.items);
            }
          },
        ),
        floatingActionButton: const SearchButton(),
      ),
    );
  }
}
