import pandas as pd
import numpy as np
from pandas.api.types import (
    is_numeric_dtype,
    is_string_dtype,
    is_categorical_dtype
)

def detect_measurement_type(series):
    # Drop NA
    s = series.dropna()

    # 1. Categorical / String → Nominal or Ordinal
    if is_string_dtype(s) or is_categorical_dtype(s):
        unique_vals = list(s.unique())

        try:
            sorted_vals = sorted(unique_vals)
            if unique_vals != sorted_vals:
                return "Nominal (likely)"
            else:
                return "Ordinal (possible)"
        except:
            return "Nominal"

    # 2. Numeric data
    elif is_numeric_dtype(s):
        unique_count = s.nunique()
        total_count = len(s)

        # Few unique values → could be ordinal
        if unique_count < 10:
            return "Ordinal (discrete numeric)"

        # Check zero presence
        if (s == 0).any():
            return "Ratio (likely)"

        return "Interval or Ratio (needs context)"

    return "Unknown"	
	
df = pd.DataFrame({
    "gender": ["M", "F", "F", "M"],
    "rating": [1, 2, 3, 4],
    "temperature": [36.5, 37.0, 38.2, 36.8],
    "income": [20000, 35000, 50000, 42000],
    "hieght": [3.6,6.4,3.6,9.3],
    "temp":[43.5,56.3,23.5,34.2]
})

for col in df.columns:
    print(col, "→", detect_measurement_type(df[col]))