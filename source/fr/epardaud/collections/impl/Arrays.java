package fr.epardaud.collections.impl;

import java.lang.reflect.Array;

public class Arrays {
	public static <T> T[] makeCellArray(int length) throws ClassNotFoundException{
		Class<T> klass = (Class<T>) Class.forName("fr.epardaud.collections.Cell");
		return (T[]) Array.newInstance(klass, length);
	}
}
