namespace Debug
{
	void Print(FString msg, const FLinearColor Color = FLinearColor::MakeRandomColor())
	{
		PrintToScreen(msg, 7.f, Color);
	}

	void Print(FString msg, float FValue, const FLinearColor Color = FLinearColor::MakeRandomColor())
	{
		PrintToScreen(f"{msg}: {FValue}", 7.f, Color);
	}

}