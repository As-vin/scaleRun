import SwiftUI

/// 周历切换条
struct WeeklyCalendarStrip: View {
    let weekDates: [Date]
    @Binding var selectedDate: Date

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(weekDates, id: \.self) { date in
                        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                        VStack(spacing: 6) {
                            Text(date.todayLabel)
                                .font(.system(size: 13))
                                .foregroundStyle(isSelected ? .white : Color.textSecondary)

                            Text("\(Calendar.current.component(.day, from: date))")
                                .font(.system(size: 18, weight: isSelected ? .bold : .regular))
                                .foregroundStyle(isSelected ? .white : .primary)
                        }
                        .frame(width: 48, height: 56)
                        .background(
                            Circle()
                                .fill(isSelected ? Color.black : Color.clear)
                        )
                        .id(date)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedDate = date
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .onAppear {
                if let today = weekDates.first(where: { $0.isToday }) {
                    proxy.scrollTo(today, anchor: .center)
                }
            }
        }
    }
}

#Preview {
    WeeklyCalendarStrip(
        weekDates: Date.currentWeekDates(),
        selectedDate: .constant(Date())
    )
    .padding()
}
