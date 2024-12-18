//
//  CalendarView.swift
//  Toadolist
//
//  Created by Paola Campanile on 12/12/24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var isCalendarExpanded: Bool
    let dates: [Date]
    
    // Add initialization validation
    init(selectedDate: Binding<Date>, isCalendarExpanded: Binding<Bool>, dates: [Date]) {
        self._selectedDate = selectedDate
        self._isCalendarExpanded = isCalendarExpanded
        self.dates = dates
        
        // Ensure selectedDate is initialized with a valid date from the array
        if !dates.contains(selectedDate.wrappedValue) {
            if let firstDate = dates.first {
                selectedDate.wrappedValue = firstDate
            }
        }
    }
    
    // Add date formatter
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 0) {
            if !dates.isEmpty {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(dates, id: \.self) { date in
                                DateCell(date: date,
                                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate)) {
                                    withAnimation {
                                        selectedDate = date
                                    }
                                }
                                .id(date)
                                .frame(width: 40)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    .onAppear {
                        if dates.contains(selectedDate) {
                            withAnimation {
                                proxy.scrollTo(selectedDate, anchor: .center)
                            }
                        }
                    }
                }
            } else {
                Text("No dates available")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            expandedCalendarSection
            
            expandCollapseButton
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
    
    private var expandedCalendarSection: some View {
        ZStack(alignment: .top) {
            if isCalendarExpanded {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding()
                .transition(.opacity)
                .accentColor(.green)
            }
        }
        .frame(maxHeight: isCalendarExpanded ? nil : 0)
        .opacity(isCalendarExpanded ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: isCalendarExpanded)
    }
    
    private var expandCollapseButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCalendarExpanded.toggle()
            }
        } label: {
            Image(systemName: isCalendarExpanded ? "chevron.up" : "chevron.down")
                .foregroundColor(.green)
                .padding(8)
                .background(Color(UIColor.systemBackground))
                .clipShape(Circle())
                .shadow(radius: 1)
        }
        .padding(.vertical, 8)
    }
}

struct DateCell: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void
    
    // Add calendar instance
    private let calendar = Calendar.current
    
    var body: some View {
        VStack {
            Text(date.formatted(.dateTime.weekday(.narrow)))
                .font(.caption2)
                .foregroundColor(.gray)
                .accessibilityHidden(true)  // Hide from VoiceOver
            
            Text(date.formatted(.dateTime.day()))
                .font(.system(.body, design: .rounded))
                .accessibilityHidden(true)  // Hide from VoiceOver
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.green : Color(UIColor.systemBackground))
        )
        .foregroundColor(isSelected ? .white : .primary)
        .onTapGesture(perform: action)
        .accessibilityElement(children: .ignore)
        .accessibilityHint("Select a Date")
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        
    }
    
    // Add computed property for accessibility label
    private var accessibilityLabel: String {
        let weekday = date.formatted(.dateTime.weekday(.wide))  // Full weekday name
        let day = date.formatted(.dateTime.day())
        return "\(weekday) \(day)"
    }
}


#Preview {
    let today = Date()
    let dates = (0...14).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: today) }
    return CalendarView(
        selectedDate: .constant(today),
        isCalendarExpanded: .constant(false),
        dates: dates
    )
}
