import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/search/search.dart';
import 'package:timezones/time_zones/time_zones.dart';

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
    return Scaffold(
      body: BlocBuilder<TimeZonesBloc, TimeZonesState>(
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async => context
                .read<TimeZonesBloc>()
                .add(const TimeZonesFetchRequested()),
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton(
            onPressed: () async {
              final bloc = context.read<TimeZonesBloc>();
              final query =
                  await Navigator.of(context).push(SearchPage.route());
              if (query != null) {
                bloc.add(TimeZonesAddRequested(city: query));
              }
            },
            child: const Icon(Icons.search),
          )
        ],
      ),
    );
  }
}
