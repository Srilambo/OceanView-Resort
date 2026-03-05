package com.oceanview.util;

import com.google.gson.JsonSerializer;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonDeserializationContext;
import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.temporal.ChronoField;

public class LocalDateTimeAdapter implements JsonSerializer<LocalDateTime>, JsonDeserializer<LocalDateTime> {

    // Serializer: always output clean ISO-8601 without fractional seconds
    // e.g. "2026-03-18T14:00:00"
    private static final DateTimeFormatter SERIALIZER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

    // Deserializer: accept ISO-8601 with or without fractional seconds
    private static final DateTimeFormatter DESERIALIZER = new DateTimeFormatterBuilder()
            .appendPattern("yyyy-MM-dd'T'HH:mm:ss")
            .optionalStart()
            .appendFraction(ChronoField.NANO_OF_SECOND, 0, 9, true)
            .optionalEnd()
            .toFormatter();

    @Override
    public JsonElement serialize(LocalDateTime dateTime, Type typeOfSrc, JsonSerializationContext context) {
        return new JsonPrimitive(SERIALIZER.format(dateTime));
    }

    @Override
    public LocalDateTime deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) {
        return LocalDateTime.parse(json.getAsString(), DESERIALIZER);
    }
}